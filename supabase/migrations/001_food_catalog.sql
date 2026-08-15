-- Kalorie food catalog. Public read, pipeline writes via service_role.

create table nutrient_defs (

  code text primary key,
  name_nl text not null,
  unit text not null,
  "group" text not null check ("group" in (
    'energy', 'macro', 'carb', 'fat', 'mineral', 'vitamin', 'other'
  )),
  decimals smallint not null default 1,
  is_core boolean not null default false,
  sort_order smallint not null default 0
);

create table products (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('generic', 'branded')),
  source_primary text not null check (source_primary in ('nevo', 'off', 'kalorie')),
  nevo_code text,
  off_id text,
  name text not null,
  brand text,
  category text,
  name_normalized text not null,
  brand_normalized text,
  match_key text,
  energy_kcal_100g numeric(8, 2) not null,
  protein_100g numeric(8, 2) not null,
  carbs_100g numeric(8, 2) not null,
  fat_100g numeric(8, 2) not null,
  fiber_100g numeric(8, 2),
  sugars_100g numeric(8, 2),
  sat_fat_100g numeric(8, 2),
  salt_100g numeric(8, 2),
  alcohol_100g numeric(8, 2),
  nutrients jsonb not null default '{}'::jsonb,
  quality_score smallint not null default 0 check (quality_score between 0 and 100),
  popularity integer not null default 0,
  nl_relevance smallint not null default 0 check (nl_relevance between 0 and 100),
  is_published boolean not null default false,
  generic_product_id uuid references products (id) on delete set null,
  data_version integer not null default 1,
  source_updated_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint products_nevo_code_unique unique (nevo_code),
  constraint products_off_id_unique unique (off_id)
);

create unique index products_branded_match_key_uidx
  on products (match_key)
  where kind = 'branded' and match_key is not null;

create index products_published_idx on products (is_published) where is_published;
create index products_kind_idx on products (kind);
create index products_quality_idx on products (quality_score desc);
create index products_popularity_idx on products (popularity desc);
create index products_data_version_idx on products (data_version);

alter table products
  add column search_text text
  generated always as (
    trim(both from (name_normalized || ' ' || coalesce(brand_normalized, '')))
  ) stored;

create table product_barcodes (
  barcode text primary key,
  product_id uuid not null references products (id) on delete cascade,
  is_primary boolean not null default true
);

create index product_barcodes_product_idx on product_barcodes (product_id);

create table product_aliases (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products (id) on delete cascade,
  alias text not null,
  alias_normalized text not null,
  source text not null default 'kalorie' check (source in ('kalorie', 'nevo', 'off')),
  constraint product_aliases_unique unique (product_id, alias_normalized)
);

create table product_portions (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products (id) on delete cascade,
  label text not null,
  grams numeric(8, 2) not null check (grams > 0),
  is_default boolean not null default false,
  source text not null default 'kalorie',
  constraint product_portions_label_unique unique (product_id, label)
);

create unique index product_portions_one_default_uidx
  on product_portions (product_id)
  where is_default;

create table product_sources (
  product_id uuid primary key references products (id) on delete cascade,
  nevo_version text,
  off_last_modified timestamptz,
  raw_hash text
);

create table duplicate_candidates (
  id uuid primary key default gen_random_uuid(),
  product_a uuid not null references products (id) on delete cascade,
  product_b uuid not null references products (id) on delete cascade,
  reason text not null check (reason in ('same_barcode', 'name_brand', 'fuzzy')),
  similarity numeric(5, 4),
  status text not null default 'open' check (status in ('open', 'merged', 'kept_separate')),
  created_at timestamptz not null default now(),
  constraint duplicate_candidates_pair unique (product_a, product_b)
);

create table catalog_meta (
  id smallint primary key default 1 check (id = 1),
  version integer not null default 0,
  nevo_version text,
  off_dump_date date,
  product_count integer not null default 0,
  published_at timestamptz
);

insert into catalog_meta (id, version) values (1, 0);

create table import_runs (
  id uuid primary key default gen_random_uuid(),
  source text not null,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  rows_in integer not null default 0,
  inserted integer not null default 0,
  updated integer not null default 0,
  skipped integer not null default 0,
  rejected integer not null default 0,
  notes text
);

create index product_aliases_product_idx on product_aliases (product_id);
create index product_portions_product_idx on product_portions (product_id);
create index products_generic_product_id_idx on products (generic_product_id);
create index duplicate_candidates_a_idx on duplicate_candidates (product_a);
create index duplicate_candidates_b_idx on duplicate_candidates (product_b);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger products_set_updated_at
  before update on products
  for each row execute function public.set_updated_at();

revoke all on function public.set_updated_at() from public, anon, authenticated;

alter table nutrient_defs enable row level security;
alter table products enable row level security;
alter table product_barcodes enable row level security;
alter table product_aliases enable row level security;
alter table product_portions enable row level security;
alter table product_sources enable row level security;
alter table duplicate_candidates enable row level security;
alter table catalog_meta enable row level security;
alter table import_runs enable row level security;

create policy nutrient_defs_select on nutrient_defs
  for select to anon, authenticated using (true);

create policy products_select on products
  for select to anon, authenticated using (is_published);

create policy product_barcodes_select on product_barcodes
  for select to anon, authenticated using (
    exists (
      select 1 from products p
      where p.id = product_id and p.is_published
    )
  );

create policy product_aliases_select on product_aliases
  for select to anon, authenticated using (
    exists (
      select 1 from products p
      where p.id = product_id and p.is_published
    )
  );

create policy product_portions_select on product_portions
  for select to anon, authenticated using (
    exists (
      select 1 from products p
      where p.id = product_id and p.is_published
    )
  );

create policy catalog_meta_select on catalog_meta
  for select to anon, authenticated using (true);

grant select on table
  public.nutrient_defs,
  public.products,
  public.product_barcodes,
  public.product_aliases,
  public.product_portions,
  public.catalog_meta
to anon, authenticated;
