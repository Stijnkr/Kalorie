-- NEVO recipe composition (relative ingredient amounts).

create table if not exists product_recipes (
  product_nevo_code text not null,
  ingredient_nevo_code text not null,
  relative_amount numeric(8, 3) not null,
  ingredient_name text,
  primary key (product_nevo_code, ingredient_nevo_code)
);

alter table product_recipes enable row level security;

drop policy if exists product_recipes_select on product_recipes;
create policy product_recipes_select on product_recipes
  for select to anon, authenticated using (true);

grant select on table public.product_recipes to anon, authenticated;
