-- Idempotent follow-up: LWW op client-updated_at, weekdag voor wegen,
-- en expliciete grants voor de Data API.

alter table public.reminders
  add column if not exists weekday integer not null default 1;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'reminders_weekday_check'
  ) then
    alter table public.reminders
      add constraint reminders_weekday_check check (weekday between 1 and 7);
  end if;
end $$;

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

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.user_settings to authenticated;
grant select, insert, update, delete on public.diary_entries to authenticated;
grant select, insert, update, delete on public.weight_entries to authenticated;
grant select, insert, update, delete on public.water_entries to authenticated;
grant select, insert, update, delete on public.custom_foods to authenticated;
grant select, insert, update, delete on public.recipes to authenticated;
grant select, insert, update, delete on public.reminders to authenticated;
