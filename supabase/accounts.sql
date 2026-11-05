-- The Usual: usernames, user search and invitations between accounts.
-- Run this ONCE in the Supabase SQL editor, after schema.sql. It is safe to run again.

-- 1. Usernames --------------------------------------------------------------
create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  created_at timestamptz not null default now(),
  constraint username_format check (username ~ '^[a-z0-9_]{3,20}$')
);
create unique index if not exists profiles_username_key on public.profiles (username);
alter table public.profiles enable row level security;

drop policy if exists "Read own profile" on public.profiles;
create policy "Read own profile" on public.profiles
  for select to authenticated using (user_id = auth.uid());
grant select on public.profiles to authenticated;

-- 2. Invitations between users ---------------------------------------------
create table if not exists public.library_user_invites (
  id uuid primary key default gen_random_uuid(),
  library_id uuid not null references public.libraries(id) on delete cascade,
  from_user uuid not null references auth.users(id) on delete cascade,
  to_user uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted', 'declined')),
  created_at timestamptz not null default now(),
  unique (library_id, to_user)
);
-- RLS on with no policies: the table can only be reached through the functions below.
alter table public.library_user_invites enable row level security;

-- 3. Functions --------------------------------------------------------------
create or replace function public.set_username(new_name text)
returns text language plpgsql security definer set search_path = '' as $$
declare n text := lower(trim(coalesce(new_name, '')));
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  if n !~ '^[a-z0-9_]{3,20}$' then
    raise exception 'Usernames are 3 to 20 letters, numbers or underscores';
  end if;
  begin
    insert into public.profiles(user_id, username) values (auth.uid(), n)
      on conflict (user_id) do update set username = excluded.username;
  exception when unique_violation then
    raise exception 'That username is taken';
  end;
  return n;
end;
$$;

create or replace function public.search_users(q text)
returns table(user_id uuid, username text, in_my_library boolean, invited boolean)
language plpgsql stable security definer set search_path = '' as $$
declare qq text := lower(trim(coalesce(q, '')));
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  if length(qq) < 3 then return; end if;
  return query
    select p.user_id, p.username,
      exists (select 1 from public.library_members a
              join public.library_members b on a.library_id = b.library_id
              where a.user_id = auth.uid() and b.user_id = p.user_id),
      exists (select 1 from public.library_user_invites i
              where i.to_user = p.user_id and i.from_user = auth.uid() and i.status = 'pending')
    from public.profiles p
    where p.user_id <> auth.uid() and starts_with(p.username, qq)
    order by p.username
    limit 8;
end;
$$;

create or replace function public.send_invite(target uuid)
returns void language plpgsql security definer set search_path = '' as $$
declare lib uuid;
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  select m.library_id into lib from public.library_members m where m.user_id = auth.uid();
  if lib is null then raise exception 'Start your library first'; end if;
  if target = auth.uid() then raise exception 'That is you'; end if;
  if not exists (select 1 from public.profiles p where p.user_id = target) then
    raise exception 'No such user';
  end if;
  if exists (select 1 from public.library_members m where m.library_id = lib and m.user_id = target) then
    raise exception 'They are already in your library';
  end if;
  insert into public.library_user_invites(library_id, from_user, to_user)
    values (lib, auth.uid(), target)
    on conflict (library_id, to_user)
    do update set status = 'pending', from_user = auth.uid(), created_at = now();
end;
$$;

create or replace function public.my_invites()
returns table(id uuid, library_name text, from_username text)
language sql stable security definer set search_path = '' as $$
  select i.id, l.name, p.username
  from public.library_user_invites i
  join public.libraries l on l.id = i.library_id
  left join public.profiles p on p.user_id = i.from_user
  where i.to_user = auth.uid() and i.status = 'pending'
  order by i.created_at desc;
$$;

create or replace function public.respond_invite(invite_id uuid, accept boolean)
returns uuid language plpgsql security definer set search_path = '' as $$
declare inv record; cur uuid; cnt int;
begin
  if auth.uid() is null then raise exception 'Sign in first'; end if;
  select * into inv from public.library_user_invites i
    where i.id = invite_id and i.to_user = auth.uid() and i.status = 'pending';
  if not found then raise exception 'That invitation is no longer available'; end if;
  if not accept then
    update public.library_user_invites set status = 'declined' where id = invite_id;
    return null;
  end if;
  if not exists (select 1 from public.library_members m
                 where m.library_id = inv.library_id and m.user_id = inv.from_user) then
    raise exception 'That invitation is no longer available';
  end if;
  select m.library_id into cur from public.library_members m where m.user_id = auth.uid();
  if cur is not null and cur <> inv.library_id then
    select count(*) into cnt from public.library_members m where m.library_id = cur;
    if cnt > 1 then raise exception 'You already share a library with someone else'; end if;
    -- a library you started alone is replaced by the one you were invited to
    delete from public.libraries where id = cur;
  end if;
  insert into public.library_members(library_id, user_id, role)
    values (inv.library_id, auth.uid(), 'member') on conflict do nothing;
  update public.library_user_invites set status = 'accepted' where id = invite_id;
  return inv.library_id;
end;
$$;

create or replace function public.list_members()
returns table(username text, is_me boolean)
language sql stable security definer set search_path = '' as $$
  select p.username, m.user_id = auth.uid()
  from public.library_members m
  left join public.profiles p on p.user_id = m.user_id
  where m.library_id = (select x.library_id from public.library_members x where x.user_id = auth.uid())
  order by m.joined_at;
$$;

revoke all on function public.set_username(text) from public;
revoke all on function public.search_users(text) from public;
revoke all on function public.send_invite(uuid) from public;
revoke all on function public.my_invites() from public;
revoke all on function public.respond_invite(uuid, boolean) from public;
revoke all on function public.list_members() from public;
grant execute on function public.set_username(text) to authenticated;
grant execute on function public.search_users(text) to authenticated;
grant execute on function public.send_invite(uuid) to authenticated;
grant execute on function public.my_invites() to authenticated;
grant execute on function public.respond_invite(uuid, boolean) to authenticated;
grant execute on function public.list_members() to authenticated;

-- 4. A private shelf for each account --------------------------------------
-- The Together shelf lives in library_state (shared). "Mine" lives here, readable only by its owner.
create table if not exists public.user_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.user_state enable row level security;

drop policy if exists "Read own shelf" on public.user_state;
create policy "Read own shelf" on public.user_state
  for select to authenticated using (user_id = auth.uid());
drop policy if exists "Create own shelf" on public.user_state;
create policy "Create own shelf" on public.user_state
  for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "Update own shelf" on public.user_state;
create policy "Update own shelf" on public.user_state
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
grant select, insert, update on public.user_state to authenticated;

-- 5. Lock the door -----------------------------------------------------------
-- Supabase gives the "anon" role (anyone with the public key, signed in or not) execute rights on new
-- functions by default. Every function above already refuses callers who aren't signed in, but there is
-- no reason to let strangers reach them at all.
revoke execute on function public.set_username(text) from anon;
revoke execute on function public.search_users(text) from anon;
revoke execute on function public.send_invite(uuid) from anon;
revoke execute on function public.my_invites() from anon;
revoke execute on function public.respond_invite(uuid, boolean) from anon;
revoke execute on function public.list_members() from anon;
revoke execute on function public.create_library(text) from anon;
revoke execute on function public.create_library_invite() from anon;
revoke execute on function public.join_library(text) from anon;
revoke execute on function public.is_library_member(uuid) from anon;
