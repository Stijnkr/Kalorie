-- Bij verwijderen eerst de sessies doden, zodat een gestolen refresh-token
-- niet blijft werken nadat het account weg is.
--
-- Let op: auth.refresh_tokens.user_id is een varchar, geen uuid. Zonder de
-- cast faalt de vergelijking met "operator does not exist: character varying =
-- uuid" en komt de hele functie niet verder.
create or replace function public.delete_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  uid uuid := (select auth.uid());
begin
  if uid is null then
    raise exception 'niet ingelogd' using errcode = '42501';
  end if;
  delete from auth.refresh_tokens where user_id = uid::text;
  delete from auth.sessions where user_id = uid;
  delete from auth.users where id = uid;
end;
$$;

revoke all on function public.delete_account() from public, anon;
grant execute on function public.delete_account() to authenticated;
