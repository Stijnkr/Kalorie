-- Aliassen bepaalden wel of een product in de resultaten kwam, maar telden niet
-- mee in de sortering: "havermout" gaf "Pap havermout-" boven "Vlokken haver-",
-- terwijl dat laatste letterlijk de alias havermout draagt.
--
-- Dezelfde tiers als voor de naam, licht afgewaardeerd (0.9) zodat een echte
-- naamtreffer wint van een synoniem. Het filteren gebeurt in `hits`, pas daarna
-- rekent de lateral de alias-score uit — andersom scant hij alle producten
-- (146 ms i.p.v. 35 ms op 2328 rijen, en dat loopt hard op met branded erbij).

create or replace function search_products(q text, lim int default 30)
returns setof products
language sql
stable
set search_path = public, extensions
as $$
  with n as (
    select public.immutable_unaccent(lower(trim(q))) as qn
  ),
  hits as (
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
  )
  select h.*
  from hits h, n
  left join lateral (
    select max(
      case
        when a.alias_normalized = n.qn then 1.0
        when left(a.alias_normalized, char_length(n.qn) + 1) = n.qn || ' ' then 0.95
        when position(' ' || n.qn || ' ' in ' ' || a.alias_normalized || ' ') > 0 then 0.8
        when left(a.alias_normalized, char_length(n.qn)) = n.qn then 0.6
        else 0.0
      end
    ) as tier
    from product_aliases a
    where a.product_id = h.id
  ) al on true
  order by
    (
      greatest(
        similarity(h.search_text, n.qn),
        case
          when h.name_normalized = n.qn then 1.0
          when left(h.name_normalized, char_length(n.qn) + 1) = n.qn || ' ' then 0.95
          when position(' ' || n.qn || ' ' in ' ' || h.name_normalized || ' ') > 0 then 0.8
          when left(h.name_normalized, char_length(n.qn)) = n.qn then 0.6
          else 0.0
        end,
        coalesce(al.tier, 0) * 0.9
      ) * 0.40
      + (ln(1 + greatest(h.popularity, 0)) / ln(10001)) * 0.25
      + (h.quality_score / 100.0) * 0.15
      + (h.nl_relevance / 100.0) * 0.12
      + case
          when char_length(n.qn) <= 12 and h.kind = 'generic' then 0.08
          else 0
        end
    ) desc,
    char_length(h.name),
    h.name
  limit greatest(1, least(coalesce(lim, 30), 100));
$$;
