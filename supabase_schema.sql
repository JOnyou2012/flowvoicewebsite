-- ============================================================
-- FlowVoice Supabase Schema
-- Paste into: Dashboard > SQL Editor > New Query > Run
--
-- Plans are keyed by human-readable `name` ('free', 'enterprise').
-- Organizations use `id` (uuid) + `name` + unique `org_number`.
-- ============================================================


-- 1. Create tables ────────────────────────────────────────────

-- No separate UUID for plans — the plan *is* identified by name.
create table public.plans (
    name        text primary key,
    description text,
    created_at  timestamptz not null default now()
);

create table public.organizations (
    id          uuid primary key default gen_random_uuid(),
    name        text not null,
    org_number  text not null unique,
    created_at  timestamptz not null default now()
);

create table public.profiles (
    id               uuid primary key references auth.users(id) on delete cascade,
    display_name     text,
    avatar_url       text,
    plan_name        text not null default 'free' references public.plans(name),
    organization_id  uuid references public.organizations(id),
    locale           text not null default 'zh-CN',
    created_at       timestamptz not null default now(),
    updated_at       timestamptz not null default now()
);


-- 2. Seed plans ───────────────────────────────────────────────

insert into public.plans (name, description) values
    ('free',       'Free tier — unlimited credits'),
    ('enterprise', 'Enterprise tier — organisation customisation');


-- 3. Row Level Security ───────────────────────────────────────

alter table public.plans enable row level security;
alter table public.organizations enable row level security;
alter table public.profiles enable row level security;

create policy "Anyone can read plans"
    on public.plans for select
    using (true);

create policy "Members can read their own org"
    on public.organizations for select
    using (
        id in (
            select organization_id
            from public.profiles
            where profiles.id = auth.uid()
        )
    );

create policy "Users can read their own profile"
    on public.profiles for select
    using (id = auth.uid());

create policy "Users can update their own profile"
    on public.profiles for update
    using (id = auth.uid())
    with check (id = auth.uid());


-- 4. Auto-create a profile on signup ──────────────────────────

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into public.profiles (id)
    values (new.id);
    return new;
end;
$$;

create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function public.handle_new_user();


-- 5. Auto-touch updated_at on profile changes ─────────────────

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

create trigger profiles_updated_at
    before update on public.profiles
    for each row
    execute function public.touch_updated_at();
