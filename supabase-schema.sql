-- INVOTATION V25 — Accountless QR Device Pairing (current schema)
-- Enable Anonymous Sign-Ins in Supabase Authentication settings before using sync.
-- This script is idempotent and includes the RLS recursion fix + sync indexes used by the live project.

create table if not exists public.invotation_spaces (
  id uuid primary key,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.invotation_space_members (
  space_id uuid not null references public.invotation_spaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (space_id, user_id)
);

create table if not exists public.invotation_pair_tokens (
  token_hash text primary key,
  space_id uuid not null references public.invotation_spaces(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null
);

create index if not exists idx_invotation_space_members_user_id on public.invotation_space_members(user_id);
create index if not exists idx_invotation_pair_tokens_space_id on public.invotation_pair_tokens(space_id);
create index if not exists idx_invotation_pair_tokens_created_by on public.invotation_pair_tokens(created_by);
create index if not exists idx_invotation_pair_tokens_expires_at on public.invotation_pair_tokens(expires_at);

alter table public.invotation_spaces enable row level security;
alter table public.invotation_space_members enable row level security;
alter table public.invotation_pair_tokens enable row level security;

revoke all on table public.invotation_spaces from anon, authenticated;
revoke all on table public.invotation_space_members from anon, authenticated;
revoke all on table public.invotation_pair_tokens from anon, authenticated;

grant select, update on table public.invotation_spaces to authenticated;
grant select on table public.invotation_space_members to authenticated;

create or replace function public.is_invotation_space_member(p_space_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.invotation_space_members
    where space_id = p_space_id
      and user_id = auth.uid()
  );
$$;

revoke all on function public.is_invotation_space_member(uuid) from public;
revoke all on function public.is_invotation_space_member(uuid) from anon;
grant execute on function public.is_invotation_space_member(uuid) to authenticated;

drop policy if exists "members_can_select_space" on public.invotation_spaces;
create policy "members_can_select_space"
on public.invotation_spaces
for select
to authenticated
using (public.is_invotation_space_member(id));

drop policy if exists "members_can_update_space" on public.invotation_spaces;
create policy "members_can_update_space"
on public.invotation_spaces
for update
to authenticated
using (public.is_invotation_space_member(id))
with check (public.is_invotation_space_member(id));

drop policy if exists "members_can_view_members" on public.invotation_space_members;
create policy "members_can_view_members"
on public.invotation_space_members
for select
to authenticated
using (public.is_invotation_space_member(space_id));

create or replace function public.create_invotation_space(
  p_space_id uuid,
  p_payload jsonb
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  insert into public.invotation_spaces(id,payload,updated_at)
  values (p_space_id,coalesce(p_payload,'{}'::jsonb),now());

  insert into public.invotation_space_members(space_id,user_id)
  values (p_space_id,auth.uid());

  return p_space_id;
end;
$$;

create or replace function public.create_invotation_pair_token(
  p_space_id uuid,
  p_token_hash text
)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  v_expiry timestamptz := now() + interval '10 minutes';
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if not exists (
    select 1 from public.invotation_space_members
    where space_id = p_space_id and user_id = auth.uid()
  ) then
    raise exception 'Not a member of this sync space';
  end if;

  delete from public.invotation_pair_tokens
  where expires_at <= now()
     or created_by = auth.uid();

  insert into public.invotation_pair_tokens(token_hash,space_id,created_by,expires_at)
  values (p_token_hash,p_space_id,auth.uid(),v_expiry);

  return v_expiry;
end;
$$;

create or replace function public.redeem_invotation_pair_token(
  p_token_hash text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_space_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select space_id into v_space_id
  from public.invotation_pair_tokens
  where token_hash = p_token_hash
    and expires_at > now()
  for update;

  if v_space_id is null then
    raise exception 'Pair token invalid or expired';
  end if;

  insert into public.invotation_space_members(space_id,user_id)
  values (v_space_id,auth.uid())
  on conflict do nothing;

  delete from public.invotation_pair_tokens
  where token_hash = p_token_hash;

  return v_space_id;
end;
$$;

create or replace function public.leave_invotation_space(
  p_space_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  delete from public.invotation_space_members
  where space_id = p_space_id
    and user_id = auth.uid();
end;
$$;

revoke all on function public.create_invotation_space(uuid,jsonb) from public;
revoke all on function public.create_invotation_pair_token(uuid,text) from public;
revoke all on function public.redeem_invotation_pair_token(text) from public;
revoke all on function public.leave_invotation_space(uuid) from public;
revoke all on function public.create_invotation_space(uuid,jsonb) from anon;
revoke all on function public.create_invotation_pair_token(uuid,text) from anon;
revoke all on function public.redeem_invotation_pair_token(text) from anon;
revoke all on function public.leave_invotation_space(uuid) from anon;

grant execute on function public.create_invotation_space(uuid,jsonb) to authenticated;
grant execute on function public.create_invotation_pair_token(uuid,text) to authenticated;
grant execute on function public.redeem_invotation_pair_token(text) to authenticated;
grant execute on function public.leave_invotation_space(uuid) to authenticated;
