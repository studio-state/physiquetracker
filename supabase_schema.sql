-- Physique Tracker — Supabase schema
-- Run this entire script in Supabase SQL Editor.
-- It creates per-user tables and Row Level Security.

create extension if not exists pgcrypto;

create table if not exists public.pt_workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  sort_order integer not null,
  created_at timestamptz not null default now(),
  unique(user_id, sort_order)
);

create table if not exists public.pt_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workout_id uuid not null references public.pt_workouts(id) on delete cascade,
  name text not null,
  sets integer not null default 3,
  min_reps integer not null default 8,
  max_reps integer not null default 12,
  exercise_type text not null default 'compound' check (exercise_type in ('compound','isolation')),
  sort_order integer not null,
  created_at timestamptz not null default now(),
  unique(user_id, workout_id, sort_order)
);

create table if not exists public.pt_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workout_name text not null,
  completed_at timestamptz not null default now()
);

create table if not exists public.pt_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_id uuid not null references public.pt_sessions(id) on delete cascade,
  exercise_name text not null,
  set_number integer not null,
  weight numeric,
  reps integer,
  min_reps integer,
  max_reps integer
);

create table if not exists public.pt_body_weight (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  recorded_at timestamptz not null,
  weight numeric not null,
  unique(user_id, recorded_at)
);

alter table public.pt_workouts enable row level security;
alter table public.pt_exercises enable row level security;
alter table public.pt_sessions enable row level security;
alter table public.pt_sets enable row level security;
alter table public.pt_body_weight enable row level security;

drop policy if exists "own workouts" on public.pt_workouts;
create policy "own workouts" on public.pt_workouts for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "own exercises" on public.pt_exercises;
create policy "own exercises" on public.pt_exercises for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "own sessions" on public.pt_sessions;
create policy "own sessions" on public.pt_sessions for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "own sets" on public.pt_sets;
create policy "own sets" on public.pt_sets for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "own body weight" on public.pt_body_weight;
create policy "own body weight" on public.pt_body_weight for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

-- Helpful indexes
create index if not exists pt_workouts_user_sort on public.pt_workouts(user_id, sort_order);
create index if not exists pt_exercises_workout_sort on public.pt_exercises(workout_id, sort_order);
create index if not exists pt_sessions_user_date on public.pt_sessions(user_id, completed_at desc);
create index if not exists pt_sets_session on public.pt_sets(session_id);
create index if not exists pt_body_weight_user_date on public.pt_body_weight(user_id, recorded_at desc);
