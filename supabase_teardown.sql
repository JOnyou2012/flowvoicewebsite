-- Run in Supabase SQL Editor BEFORE re-running supabase_schema.sql
-- Order: triggers → functions → tables (FK order)

drop trigger if exists on_auth_user_created on auth.users;
drop trigger if exists profiles_updated_at on public.profiles;

drop function if exists public.handle_new_user();
drop function if exists public.touch_updated_at();

drop table if exists public.profiles cascade;
drop table if exists public.organizations cascade;
drop table if exists public.plans cascade;
