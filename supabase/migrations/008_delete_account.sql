-- "Account verwijderen" vanuit de app. De client mag auth.users niet aanraken,
-- dus dit gaat via een functie die alleen de eigen rij wist. Alle
-- gebruikerstabellen hangen met on delete cascade aan auth.users, dus daarmee
-- verdwijnt het logboek van de server mee.
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
  delete from auth.users where id = uid;
end;
$$;

revoke all on function public.delete_account() from public, anon;
grant execute on function public.delete_account() to authenticated;
