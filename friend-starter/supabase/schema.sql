-- AI Job Mission Control — clean multi-user starter schema
-- Run against YOUR OWN Supabase project only.

create extension if not exists pgcrypto;

create table if not exists public.user_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  headline text,
  location text,
  linkedin_url text,
  github_url text,
  resume_confirmed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_job_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  target_titles text[] not null default '{}',
  target_locations text[] not null default '{}',
  target_companies text[] not null default '{}',
  sponsorship_required boolean not null default false,
  minimum_fit numeric(3,1) not null default 7.0,
  alert_cadence text not null default 'Daily',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_alert_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email_enabled boolean not null default false,
  in_app_enabled boolean not null default true,
  cadence text not null default 'Daily',
  minimum_fit numeric(3,1) not null default 7.0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_resume_sources (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  file_name text not null,
  storage_path text not null,
  mime_type text,
  parsed_profile jsonb not null default '{}'::jsonb,
  is_primary boolean not null default true,
  confirmed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.job_catalog (
  id uuid primary key default gen_random_uuid(),
  company text not null,
  title text not null,
  location text,
  apply_url text,
  source_url text,
  job_description text,
  sponsorship_note text,
  is_open boolean not null default true,
  first_seen_at timestamptz not null default now(),
  last_checked_at timestamptz,
  unique (apply_url)
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  catalog_id uuid references public.job_catalog(id) on delete set null,
  company text not null,
  title text not null,
  location text,
  apply_url text,
  job_description text,
  status text not null default 'Review',
  fit_score numeric(3,1),
  fit_assessment jsonb,
  selection_rationale text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.job_status_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  job_id uuid not null references public.jobs(id) on delete cascade,
  old_status text,
  new_status text not null,
  changed_at timestamptz not null default now()
);

create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  company text,
  title text,
  linkedin_url text,
  status text not null default 'To Contact',
  invite_note text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.outreach_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  contact_id uuid not null references public.contacts(id) on delete cascade,
  channel text not null default 'LinkedIn',
  action text not null,
  message text,
  occurred_at timestamptz not null default now()
);

create table if not exists public.skill_gap_projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  job_id uuid references public.jobs(id) on delete set null,
  project_title text not null,
  description text,
  build_plan text,
  skills text[] not null default '{}',
  status text not null default 'Planned',
  resume_eligible boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.resume_versions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  job_id uuid references public.jobs(id) on delete set null,
  name text not null,
  latex_path text,
  pdf_path text,
  validation_report jsonb,
  source text,
  created_at timestamptz not null default now()
);

-- Helpful indexes
create index if not exists jobs_user_status_idx on public.jobs(user_id, status);
create index if not exists jobs_user_created_idx on public.jobs(user_id, created_at desc);
create index if not exists contacts_user_status_idx on public.contacts(user_id, status);
create index if not exists resume_sources_user_idx on public.user_resume_sources(user_id, created_at desc);
create index if not exists resume_versions_user_idx on public.resume_versions(user_id, created_at desc);
create index if not exists projects_user_idx on public.skill_gap_projects(user_id, created_at desc);

-- RLS
alter table public.user_profiles enable row level security;
alter table public.user_job_preferences enable row level security;
alter table public.user_alert_preferences enable row level security;
alter table public.user_resume_sources enable row level security;
alter table public.jobs enable row level security;
alter table public.job_status_history enable row level security;
alter table public.contacts enable row level security;
alter table public.outreach_history enable row level security;
alter table public.skill_gap_projects enable row level security;
alter table public.resume_versions enable row level security;
alter table public.job_catalog enable row level security;

-- User-owned table policies
create policy "profiles_owner_all" on public.user_profiles for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "job_preferences_owner_all" on public.user_job_preferences for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "alert_preferences_owner_all" on public.user_alert_preferences for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "resume_sources_owner_all" on public.user_resume_sources for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "jobs_owner_all" on public.jobs for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "job_status_history_owner_all" on public.job_status_history for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "contacts_owner_all" on public.contacts for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "outreach_history_owner_all" on public.outreach_history for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "projects_owner_all" on public.skill_gap_projects for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "resume_versions_owner_all" on public.resume_versions for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Shared catalog: signed-in users may read, but browser clients should not write.
create policy "job_catalog_authenticated_read" on public.job_catalog for select to authenticated using (true);

-- Private source-resume bucket
insert into storage.buckets (id, name, public)
values ('resume-source-files', 'resume-source-files', false)
on conflict (id) do update set public = false;

-- Private generated-resume bucket
insert into storage.buckets (id, name, public)
values ('resume-artifacts', 'resume-artifacts', false)
on conflict (id) do update set public = false;

-- Each object path must begin with auth.uid().
create policy "resume_source_owner_select" on storage.objects for select to authenticated
using (bucket_id = 'resume-source-files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_source_owner_insert" on storage.objects for insert to authenticated
with check (bucket_id = 'resume-source-files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_source_owner_update" on storage.objects for update to authenticated
using (bucket_id = 'resume-source-files' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'resume-source-files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_source_owner_delete" on storage.objects for delete to authenticated
using (bucket_id = 'resume-source-files' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "resume_artifact_owner_select" on storage.objects for select to authenticated
using (bucket_id = 'resume-artifacts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_artifact_owner_insert" on storage.objects for insert to authenticated
with check (bucket_id = 'resume-artifacts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_artifact_owner_update" on storage.objects for update to authenticated
using (bucket_id = 'resume-artifacts' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'resume-artifacts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "resume_artifact_owner_delete" on storage.objects for delete to authenticated
using (bucket_id = 'resume-artifacts' and (storage.foldername(name))[1] = auth.uid()::text);

-- Optional privilege tightening. RLS remains the primary control.
grant select, insert, update, delete on public.user_profiles to authenticated;
grant select, insert, update, delete on public.user_job_preferences to authenticated;
grant select, insert, update, delete on public.user_alert_preferences to authenticated;
grant select, insert, update, delete on public.user_resume_sources to authenticated;
grant select, insert, update, delete on public.jobs to authenticated;
grant select, insert, update, delete on public.job_status_history to authenticated;
grant select, insert, update, delete on public.contacts to authenticated;
grant select, insert, update, delete on public.outreach_history to authenticated;
grant select, insert, update, delete on public.skill_gap_projects to authenticated;
grant select, insert, update, delete on public.resume_versions to authenticated;
grant select on public.job_catalog to authenticated;
