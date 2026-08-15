-- Alle NEVO-rijen scoren gelijk (popularity 0, quality 100, nl_relevance 100),
-- dus de tiebreak bepaalt in de praktijk de volgorde. Alfabetisch zette
-- "Melk chocolade- automaat" boven "Melk halfvolle". Korte naam = minder
-- bijzinnen = het basisproduct, dus die eerst.

create or replace function search_products(q text, lim int default 30)
returns setof products
language sql
stable
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
    char_length(p.name),
    p.name
  limit greatest(1, least(coalesce(lim, 30), 100));
$$;
