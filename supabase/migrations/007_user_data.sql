-- Gebruikersgegevens: logboek, doelen, gewicht, water, eigen producten,
-- recepten en herinneringen. Alles staat achter RLS op auth.uid().
--
-- Synchronisatie is last-write-wins op updated_at. Elke rij draagt een
-- client_id die het toestel genereert, zodat een regel die offline is gemaakt
-- bij de eerste push aan de juiste serverrij wordt gekoppeld. Verwijderen gaat
-- via deleted_at (tombstone) zodat andere toestellen de verwijdering ophalen.

-- ---------------------------------------------------------------- profielen

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, nullif(new.raw_user_meta_data ->> 'display_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------- instellingen

create table if not exists public.user_settings (
  user_id uuid primary key references auth.users (id) on delete cascade,
  kcal_goal integer not null default 2200,
  protein_goal double precision not null default 120,
  carbs_goal double precision not null default 250,
  fat_goal double precision not null default 70,
  theme text not null default 'system',
  sync_diary boolean not null default true,
  sync_weight boolean not null default true,
  updated_at timestamptz not null default now(),
  constraint user_settings_theme_check
    check (theme in ('system', 'light', 'dark'))
);

-- ---------------------------------------------------------------- logboek

create table if not exists public.diary_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  client_id text not null,
  date_key integer not null,
  meal text not null,
  food_client_id text,
  catalog_id text,
  food_name text not null,
  brand text,
  source text not null default 'custom',
  amount_g double precision not null,
  serving_label text,
  kcal double precision not null,
  protein double precision not null,
  carbs double precision not null,
  fat double precision not null,
  fiber double precision,
  sugars double precision,
  sat_fat double precision,
  salt double precision,
  logged_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint diary_entries_meal_check
    check (meal in ('breakfast', 'lunch', 'dinner', 'snack')),
  constraint diary_entries_client_unique unique (user_id, client_id)
);

create index if not exists diary_entries_user_updated_idx
  on public.diary_entries (user_id, updated_at desc);
create index if not exists diary_entries_user_day_idx
  on public.diary_entries (user_id, date_key);

-- ---------------------------------------------------------------- gewicht

create table if not exists public.weight_entries (
  user_id uuid not null references auth.users (id) on delete cascade,
  date_key integer not null,
  kg double precision not null,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (user_id, date_key)
);

create index if not exists weight_entries_user_updated_idx
  on public.weight_entries (user_id, updated_at desc);

-- ---------------------------------------------------------------- water

create table if not exists public.water_entries (
  user_id uuid not null references auth.users (id) on delete cascade,
  date_key integer not null,
  glasses integer not null default 0,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (user_id, date_key)
);

create index if not exists water_entries_user_updated_idx
  on public.water_entries (user_id, updated_at desc);

-- ---------------------------------------------------------------- eigen producten

create table if not exists public.custom_foods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  client_id text not null,
  name text not null,
  brand text,
  barcode text,
  kcal_100g double precision not null,
  protein_100g double precision not null,
  carbs_100g double precision not null,
  fat_100g double precision not null,
  fiber_100g double precision,
  sugars_100g double precision,
  sat_fat_100g double precision,
  salt_100g double precision,
  serving_g double precision,
  serving_label text,
  is_favorite boolean not null default false,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint custom_foods_client_unique unique (user_id, client_id)
);

create index if not exists custom_foods_user_updated_idx
  on public.custom_foods (user_id, updated_at desc);

-- ---------------------------------------------------------------- recepten

create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  client_id text not null,
  name text not null,
  portions integer not null default 1,
  items jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint recipes_client_unique unique (user_id, client_id),
  constraint recipes_portions_check check (portions between 1 and 99)
);

create index if not exists recipes_user_updated_idx
  on public.recipes (user_id, updated_at desc);

-- ---------------------------------------------------------------- herinneringen

create table if not exists public.reminders (
  user_id uuid not null references auth.users (id) on delete cascade,
  meal text not null,
  hour integer not null,
  minute integer not null default 0,
  enabled boolean not null default false,
  weekday integer not null default 1,
  updated_at timestamptz not null default now(),
  primary key (user_id, meal),
  constraint reminders_meal_check
    check (meal in ('breakfast', 'lunch', 'dinner', 'snack', 'weigh_in')),
  constraint reminders_hour_check check (hour between 0 and 23),
  constraint reminders_minute_check check (minute between 0 and 59),
  constraint reminders_weekday_check check (weekday between 1 and 7)
);

-- ---------------------------------------------------------------- triggers

-- Behoud de client-`updated_at` als die meekomt. Anders wordt elke push
-- `now()` en wint de laatste writer, niet de nieuwste lokale wijziging.
create or replace function public.keep_client_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.updated_at is not distinct from old.updated_at then
    new.updated_at = now();
  end if;
  return new;
end;
$$;

revoke all on function public.keep_client_updated_at() from public, anon, authenticated;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.keep_client_updated_at();

drop trigger if exists user_settings_set_updated_at on public.user_settings;
create trigger user_settings_set_updated_at
  before update on public.user_settings
  for each row execute function public.keep_client_updated_at();

drop trigger if exists diary_entries_set_updated_at on public.diary_entries;
create trigger diary_entries_set_updated_at
  before update on public.diary_entries
  for each row execute function public.keep_client_updated_at();

drop trigger if exists weight_entries_set_updated_at on public.weight_entries;
create trigger weight_entries_set_updated_at
  before update on public.weight_entries
  for each row execute function public.keep_client_updated_at();

drop trigger if exists water_entries_set_updated_at on public.water_entries;
create trigger water_entries_set_updated_at
  before update on public.water_entries
  for each row execute function public.keep_client_updated_at();

drop trigger if exists custom_foods_set_updated_at on public.custom_foods;
create trigger custom_foods_set_updated_at
  before update on public.custom_foods
  for each row execute function public.keep_client_updated_at();

drop trigger if exists recipes_set_updated_at on public.recipes;
create trigger recipes_set_updated_at
  before update on public.recipes
  for each row execute function public.keep_client_updated_at();

drop trigger if exists reminders_set_updated_at on public.reminders;
create trigger reminders_set_updated_at
  before update on public.reminders
  for each row execute function public.keep_client_updated_at();

-- ---------------------------------------------------------------- RLS

alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.diary_entries enable row level security;
alter table public.weight_entries enable row level security;
alter table public.water_entries enable row level security;
alter table public.custom_foods enable row level security;
alter table public.recipes enable row level security;
alter table public.reminders enable row level security;

drop policy if exists profiles_owner on public.profiles;
create policy profiles_owner on public.profiles
  for all to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

drop policy if exists user_settings_owner on public.user_settings;
create policy user_settings_owner on public.user_settings
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists diary_entries_owner on public.diary_entries;
create policy diary_entries_owner on public.diary_entries
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists weight_entries_owner on public.weight_entries;
create policy weight_entries_owner on public.weight_entries
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists water_entries_owner on public.water_entries;
create policy water_entries_owner on public.water_entries
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists custom_foods_owner on public.custom_foods;
create policy custom_foods_owner on public.custom_foods
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists recipes_owner on public.recipes;
create policy recipes_owner on public.recipes
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists reminders_owner on public.reminders;
create policy reminders_owner on public.reminders
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Anon mag hier niets: gebruikersgegevens zijn alleen voor de ingelogde eigenaar.
revoke all on public.profiles from anon;
revoke all on public.user_settings from anon;
revoke all on public.diary_entries from anon;
revoke all on public.weight_entries from anon;
revoke all on public.water_entries from anon;
revoke all on public.custom_foods from anon;
revoke all on public.recipes from anon;
revoke all on public.reminders from anon;

-- Nieuwe tabellen worden niet altijd automatisch aan de Data API gekoppeld.
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.user_settings to authenticated;
grant select, insert, update, delete on public.diary_entries to authenticated;
grant select, insert, update, delete on public.weight_entries to authenticated;
grant select, insert, update, delete on public.water_entries to authenticated;
grant select, insert, update, delete on public.custom_foods to authenticated;
grant select, insert, update, delete on public.recipes to authenticated;
grant select, insert, update, delete on public.reminders to authenticated;

-- handle_new_user() is een triggerfunctie; niemand hoort hem via de REST-API
-- te kunnen aanroepen.
revoke all on function public.handle_new_user() from public, anon, authenticated;
