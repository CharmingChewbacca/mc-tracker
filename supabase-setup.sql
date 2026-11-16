-- ─────────────────────────────────────────────────────────────────
--  Morgan Creative Tracker — database setup
--  Paste this whole file into Supabase → SQL Editor → Run. Run it once.
-- ─────────────────────────────────────────────────────────────────

-- One private row per user holds all of that user's tracker data.
create table if not exists public.crm_state (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  version    bigint not null default 1,
  updated_at timestamptz not null default now()
);

-- Row-level security: nobody can see or change anything
-- except a signed-in user, and only their own row.
alter table public.crm_state enable row level security;

drop policy if exists "Owner can read"   on public.crm_state;
drop policy if exists "Owner can insert" on public.crm_state;
drop policy if exists "Owner can update" on public.crm_state;

create policy "Owner can read" on public.crm_state
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "Owner can insert" on public.crm_state
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "Owner can update" on public.crm_state
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- (No delete policy on purpose: the app never deletes the row,
--  so a bug or a stolen session can't wipe it in one go.)

-- Lock the table down for everyone who isn't signed in.
revoke all on public.crm_state from anon;
grant select, insert, update on public.crm_state to authenticated;

-- Tiny function the keep-awake job calls so the free project
-- never counts as "inactive". It reveals nothing.
create or replace function public.keep_awake()
returns text language sql security definer set search_path = '' as $$
  select 'awake'::text;
$$;
grant execute on function public.keep_awake() to anon;
