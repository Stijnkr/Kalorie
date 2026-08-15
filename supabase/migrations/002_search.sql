create extension if not exists pg_trgm with schema extensions;
create extension if not exists unaccent with schema extensions;

create or replace function public.immutable_unaccent(input text)
returns text
language sql
immutable
parallel safe
strict
set search_path = ''
as $$
  select extensions.unaccent(input)
$$;

grant execute on function public.immutable_unaccent(text) to anon, authenticated;

create index products_name_trgm_idx
  on products using gin (name_normalized gin_trgm_ops);

create index products_match_key_trgm_idx
  on products using gin (match_key gin_trgm_ops);

create index products_search_text_trgm_idx
  on products using gin (search_text gin_trgm_ops);

create index product_aliases_trgm_idx
  on product_aliases using gin (alias_normalized gin_trgm_ops);

create or replace function search_products(q text, lim int default 30)
returns setof products
language sql
stable
security invoker
set search_path = public, extensions
as $$
  with n as (
    select public.immutable_unaccent(lower(trim(q))) as qn
  )
  select p.*
  from products p, n
  where p.is_published
    and n.qn <> ''
    and (
      p.search_text % n.qn
      or p.name_normalized like n.qn || '%'
      or exists (
        select 1 from product_aliases a
        where a.product_id = p.id
          and (a.alias_normalized % n.qn or a.alias_normalized like n.qn || '%')
      )
    )
  order by
    (
      greatest(
        similarity(p.search_text, n.qn),
        case when p.name_normalized like n.qn || '%' then 1.0 else 0.0 end
      ) * 0.40
      + (ln(1 + greatest(p.popularity, 0)) / ln(10001)) * 0.25
      + (p.quality_score / 100.0) * 0.15
      + (p.nl_relevance / 100.0) * 0.12
      + case
          when char_length(n.qn) <= 12 and p.kind = 'generic' then 0.08
          else 0
        end
    ) desc,
    p.name
  limit greatest(1, least(coalesce(lim, 30), 100));
$$;

create or replace function get_product_by_barcode(code text)
returns setof products
language sql
stable
security invoker
set search_path = public, extensions
as $$
  select p.*
  from product_barcodes b
  join products p on p.id = b.product_id
  where b.barcode = regexp_replace(code, '\D', '', 'g')
    and p.is_published
  limit 1;
$$;

create or replace function products_since(since_version int, lim int default 500)
returns setof products
language sql
stable
security invoker
set search_path = public, extensions
as $$
  select p.*
  from products p
  where p.is_published
    and p.data_version > since_version
  order by p.data_version, p.id
  limit greatest(1, least(coalesce(lim, 500), 2000));
$$;

grant execute on function public.search_products(text, int) to anon, authenticated;
grant execute on function public.get_product_by_barcode(text) to anon, authenticated;
grant execute on function public.products_since(int, int) to anon, authenticated;
