-- Feedback uit de app. Gebruikers mogen alleen hun eigen berichten
-- wegschrijven en terugzien. Beantwoorden gebeurt in het dashboard.

create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  kind text not null,
  message text not null,
  app_version text not null,
  platform text,
  created_at timestamptz not null default now(),
  constraint feedback_kind_check
    check (kind in ('idea', 'problem', 'other')),
  constraint feedback_message_len
    check (char_length(message) between 1 and 4000)
);

create index if not exists feedback_created_at_idx
  on public.feedback (created_at desc);

create index if not exists feedback_user_id_created_at_idx
  on public.feedback (user_id, created_at desc);

alter table public.feedback enable row level security;

drop policy if exists feedback_insert_own on public.feedback;
create policy feedback_insert_own on public.feedback
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists feedback_select_own on public.feedback;
create policy feedback_select_own on public.feedback
  for select to authenticated
  using ((select auth.uid()) = user_id);

grant select, insert on public.feedback to authenticated;
