-- The Usual: shared library storage for Supabase.
-- Run this in the Supabase SQL editor after creating a project.

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.libraries (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Our library',
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists public.library_members (
  library_id uuid not null references public.libraries(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member')),
  joined_at timestamptz not null default now(),
  primary key (library_id, user_id),
  unique (user_id)
);

create table if not exists public.library_state (
  library_id uuid primary key references public.libraries(id) on delete cascade,
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);

create table if not exists public.library_invites (
  code text primary key,
  library_id uuid not null references public.libraries(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete cascade,
  expires_at timestamptz not null default (now() + interval '7 days'),
  created_at timestamptz not null default now()
);

alter table public.libraries enable row level security;
alter table public.library_members enable row level security;
alter table public.library_state enable row level security;
alter table public.library_invites enable row level security;

-- A SECURITY DEFINER helper avoids recursive RLS evaluation on library_members.
create or replace function public.is_library_member(target_library uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.library_members m
    where m.library_id = target_library and m.user_id = auth.uid()
  );
$$;
revoke all on function public.is_library_member(uuid) from public;
grant execute on function public.is_library_member(uuid) to authenticated;

create policy "Members can read their library"
  on public.libraries for select to authenticated
  using (public.is_library_member(id));

create policy "Members can read membership"
  on public.library_members for select to authenticated
  using (public.is_library_member(library_id));

create policy "Members can read shared library state"
  on public.library_state for select to authenticated
  using (public.is_library_member(library_id));

create policy "Members can update shared library state"
  on public.library_state for insert to authenticated
  with check (public.is_library_member(library_id));
create policy "Members can replace shared library state"
  on public.library_state for update to authenticated
  using (public.is_library_member(library_id))
  with check (public.is_library_member(library_id));

create policy "Members can create invites"
  on public.library_invites for insert to authenticated
  with check (created_by = auth.uid() and public.is_library_member(library_id));
create policy "Invite creators can read their invites"
  on public.library_invites for select to authenticated
  using (created_by = auth.uid());

create or replace function public.create_library(library_name text default 'Our library')
returns uuid language plpgsql security definer set search_path = '' as $$
declare new_id uuid;
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  if exists (select 1 from public.library_members where user_id = auth.uid()) then
    raise exception 'You already belong to a library';
  end if;
  insert into public.libraries(name, created_by)
    values (left(coalesce(nullif(trim(library_name), ''), 'Our library'), 80), auth.uid()) returning id into new_id;
  insert into public.library_members(library_id, user_id, role) values (new_id, auth.uid(), 'owner');
  insert into public.library_state(library_id, content, updated_by) values (new_id, '{}'::jsonb, auth.uid());
  return new_id;
end;
$$;

create or replace function public.create_library_invite()
returns text language plpgsql security definer set search_path = '' as $$
declare code_value text; lib_id uuid;
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  select library_id into lib_id from public.library_members where user_id = auth.uid();
  if lib_id is null then raise exception 'Create a library first'; end if;
  code_value := upper(encode(extensions.gen_random_bytes(6), 'hex'));
  insert into public.library_invites(code, library_id, created_by) values (code_value, lib_id, auth.uid());
  return code_value;
end;
$$;

create or replace function public.join_library(invite_code text)
returns uuid language plpgsql security definer set search_path = '' as $$
declare lib_id uuid;
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  if exists (select 1 from public.library_members where user_id = auth.uid()) then
    raise exception 'You already belong to a library';
  end if;
  select library_id into lib_id from public.library_invites
    where code = upper(trim(invite_code)) and expires_at > now();
  if lib_id is null then raise exception 'That invite code is invalid or expired'; end if;
  insert into public.library_members(library_id, user_id, role) values (lib_id, auth.uid(), 'member');
  return lib_id;
end;
$$;

revoke all on function public.create_library(text) from public;
revoke all on function public.create_library_invite() from public;
revoke all on function public.join_library(text) from public;
grant execute on function public.create_library(text) to authenticated;
grant execute on function public.create_library_invite() to authenticated;
grant execute on function public.join_library(text) to authenticated;

grant select on public.libraries, public.library_members, public.library_state, public.library_invites to authenticated;
grant insert, update on public.library_state to authenticated;
grant insert on public.library_invites to authenticated;

