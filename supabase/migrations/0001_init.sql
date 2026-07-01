-- Minose CRM — initial schema, seed data, and row-level security
-- Generated migration. Review before running in the Supabase SQL Editor.

-- ============================================================================
-- Extensions
-- ============================================================================
create extension if not exists pgcrypto;

-- ============================================================================
-- Tables
-- ============================================================================

create table public.users_profile (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  email text,
  role text check (role in ('admin', 'sales_manager', 'sales_executive')),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.lead_sources (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  sort_order int
);

create table public.pipeline_stages (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  sort_order int,
  is_won boolean not null default false,
  is_lost boolean not null default false
);

create table public.contacts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  whatsapp text,
  email text,
  company text,
  city text,
  country text,
  contact_type text check (
    contact_type in (
      'client', 'architect', 'interior_designer', 'builder',
      'developer', 'vendor', 'manufacturer', 'other'
    )
  ) not null default 'client',
  source_id uuid references public.lead_sources (id) on delete set null,
  lead_temperature text check (lead_temperature in ('hot', 'warm', 'cold')),
  priority text check (priority in ('high', 'medium', 'low')),
  status text check (status in ('active', 'inactive', 'duplicate', 'spam')) not null default 'active',
  assigned_to uuid references public.users_profile (id) on delete set null,
  next_followup date,
  last_contacted_at timestamptz,
  tags text[],
  custom_fields jsonb not null default '{}'::jsonb,
  is_deleted boolean not null default false,
  created_by uuid references public.users_profile (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  contact_id uuid not null references public.contacts (id) on delete restrict,
  project_type text check (project_type in ('residential', 'commercial', 'hospitality', 'office')),
  stage_id uuid not null references public.pipeline_stages (id) on delete restrict,
  expected_value numeric,
  currency text not null default 'INR',
  expected_closing_date date,
  won_date date,
  lost_reason text,
  architect_contact_id uuid references public.contacts (id) on delete set null,
  interior_designer_contact_id uuid references public.contacts (id) on delete set null,
  assigned_to uuid references public.users_profile (id) on delete set null,
  custom_fields jsonb not null default '{}'::jsonb,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notes (
  id uuid primary key default gen_random_uuid(),
  contact_id uuid references public.contacts (id) on delete cascade,
  project_id uuid references public.projects (id) on delete cascade,
  note text not null,
  created_by uuid references public.users_profile (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  contact_id uuid references public.contacts (id) on delete cascade,
  project_id uuid references public.projects (id) on delete cascade,
  title text not null,
  task_type text check (task_type in ('call', 'whatsapp', 'email', 'meeting', 'visit', 'follow_up')),
  due_date date,
  priority text check (priority in ('high', 'medium', 'low')) not null default 'medium',
  assigned_to uuid references public.users_profile (id) on delete set null,
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.activity_log (
  id uuid primary key default gen_random_uuid(),
  contact_id uuid references public.contacts (id) on delete cascade,
  project_id uuid references public.projects (id) on delete cascade,
  actor_id uuid references public.users_profile (id) on delete set null,
  action_type text, -- 'created' | 'stage_changed' | 'note_added' | 'task_completed' | 'assigned' | 'followup_set'
  description text,
  created_at timestamptz not null default now()
);

create table public.custom_field_definitions (
  id uuid primary key default gen_random_uuid(),
  entity text check (entity in ('contact', 'project')) not null,
  field_key text not null,
  field_label text not null,
  field_type text check (field_type in ('text', 'number', 'date', 'select')) not null,
  options text[],
  sort_order int
);

-- ============================================================================
-- Indexes
-- ============================================================================
create index contacts_assigned_to_idx on public.contacts (assigned_to);
create index contacts_source_id_idx on public.contacts (source_id);
create index contacts_status_idx on public.contacts (status);
create index contacts_next_followup_idx on public.contacts (next_followup);

create index projects_contact_id_idx on public.projects (contact_id);
create index projects_stage_id_idx on public.projects (stage_id);
create index projects_assigned_to_idx on public.projects (assigned_to);

create index notes_contact_id_idx on public.notes (contact_id);
create index notes_project_id_idx on public.notes (project_id);

create index tasks_contact_id_idx on public.tasks (contact_id);
create index tasks_project_id_idx on public.tasks (project_id);
create index tasks_assigned_to_idx on public.tasks (assigned_to);
create index tasks_due_date_idx on public.tasks (due_date);

create index activity_log_contact_id_idx on public.activity_log (contact_id);
create index activity_log_project_id_idx on public.activity_log (project_id);

-- ============================================================================
-- updated_at maintenance
-- ============================================================================
create function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger set_contacts_updated_at
  before update on public.contacts
  for each row execute function public.set_updated_at();

create trigger set_projects_updated_at
  before update on public.projects
  for each row execute function public.set_updated_at();

-- ============================================================================
-- Seed data
-- ============================================================================
insert into public.lead_sources (name, sort_order) values
  ('Website', 1),
  ('Instagram', 2),
  ('Facebook', 3),
  ('Meta Lead Ads', 4),
  ('Google Ads', 5),
  ('WhatsApp', 6),
  ('Phone Call', 7),
  ('Referral', 8),
  ('Exhibition', 9),
  ('Walk-in', 10),
  ('Architect', 11),
  ('Interior Designer', 12),
  ('Builder', 13),
  ('LinkedIn', 14),
  ('Manual', 15)
on conflict (name) do nothing;

insert into public.pipeline_stages (name, sort_order, is_won, is_lost) values
  ('New Lead', 1, false, false),
  ('Contacted', 2, false, false),
  ('Qualified', 3, false, false),
  ('Requirement Received', 4, false, false),
  ('Quotation Sent', 5, false, false),
  ('Negotiation', 6, false, false),
  ('Won', 7, true, false),
  ('Lost', 8, false, true)
on conflict (name) do nothing;

-- ============================================================================
-- RLS helper function
-- ============================================================================
-- SECURITY DEFINER so it can read users_profile regardless of the caller's
-- own RLS grants on that table (avoids recursive policy evaluation).
create function public.current_user_role()
returns text
language sql
security definer
stable
set search_path = public, pg_temp
as $$
  select role from public.users_profile where id = auth.uid();
$$;

grant execute on function public.current_user_role() to authenticated;

-- ============================================================================
-- Table privileges
-- ============================================================================
-- RLS policies below only take effect once the role has table-level
-- privileges. Anonymous (logged-out) users get none — this app requires auth.
grant usage on schema public to authenticated;
grant select, insert, update, delete on
  public.users_profile,
  public.lead_sources,
  public.pipeline_stages,
  public.contacts,
  public.projects,
  public.notes,
  public.tasks,
  public.activity_log,
  public.custom_field_definitions
to authenticated;

-- ============================================================================
-- Row Level Security
-- ============================================================================
alter table public.users_profile enable row level security;
alter table public.lead_sources enable row level security;
alter table public.pipeline_stages enable row level security;
alter table public.contacts enable row level security;
alter table public.projects enable row level security;
alter table public.notes enable row level security;
alter table public.tasks enable row level security;
alter table public.activity_log enable row level security;
alter table public.custom_field_definitions enable row level security;

-- users_profile: everyone authenticated can read; only admins can write.
create policy "users_profile_select_all" on public.users_profile
  for select to authenticated
  using (true);

create policy "users_profile_insert_admin" on public.users_profile
  for insert to authenticated
  with check (public.current_user_role() = 'admin');

create policy "users_profile_update_admin" on public.users_profile
  for update to authenticated
  using (public.current_user_role() = 'admin')
  with check (public.current_user_role() = 'admin');

create policy "users_profile_delete_admin" on public.users_profile
  for delete to authenticated
  using (public.current_user_role() = 'admin');

-- lead_sources / pipeline_stages / custom_field_definitions:
-- read for all authenticated, write only for admins.
create policy "lead_sources_select_all" on public.lead_sources
  for select to authenticated
  using (true);

create policy "lead_sources_write_admin" on public.lead_sources
  for insert to authenticated
  with check (public.current_user_role() = 'admin');

create policy "lead_sources_update_admin" on public.lead_sources
  for update to authenticated
  using (public.current_user_role() = 'admin')
  with check (public.current_user_role() = 'admin');

create policy "lead_sources_delete_admin" on public.lead_sources
  for delete to authenticated
  using (public.current_user_role() = 'admin');

create policy "pipeline_stages_select_all" on public.pipeline_stages
  for select to authenticated
  using (true);

create policy "pipeline_stages_insert_admin" on public.pipeline_stages
  for insert to authenticated
  with check (public.current_user_role() = 'admin');

create policy "pipeline_stages_update_admin" on public.pipeline_stages
  for update to authenticated
  using (public.current_user_role() = 'admin')
  with check (public.current_user_role() = 'admin');

create policy "pipeline_stages_delete_admin" on public.pipeline_stages
  for delete to authenticated
  using (public.current_user_role() = 'admin');

create policy "custom_field_definitions_select_all" on public.custom_field_definitions
  for select to authenticated
  using (true);

create policy "custom_field_definitions_insert_admin" on public.custom_field_definitions
  for insert to authenticated
  with check (public.current_user_role() = 'admin');

create policy "custom_field_definitions_update_admin" on public.custom_field_definitions
  for update to authenticated
  using (public.current_user_role() = 'admin')
  with check (public.current_user_role() = 'admin');

create policy "custom_field_definitions_delete_admin" on public.custom_field_definitions
  for delete to authenticated
  using (public.current_user_role() = 'admin');

-- contacts: admin/sales_manager get full access. Everyone authenticated can
-- read every row. sales_executive may only write rows assigned to them or
-- currently unassigned.
create policy "contacts_select_all" on public.contacts
  for select to authenticated
  using (true);

create policy "contacts_insert_scoped" on public.contacts
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "contacts_update_scoped" on public.contacts
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  )
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "contacts_delete_scoped" on public.contacts
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

-- projects: same pattern as contacts.
create policy "projects_select_all" on public.projects
  for select to authenticated
  using (true);

create policy "projects_insert_scoped" on public.projects
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "projects_update_scoped" on public.projects
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  )
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "projects_delete_scoped" on public.projects
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

-- tasks: same pattern as contacts/projects, using the task's own assigned_to.
create policy "tasks_select_all" on public.tasks
  for select to authenticated
  using (true);

create policy "tasks_insert_scoped" on public.tasks
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "tasks_update_scoped" on public.tasks
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  )
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

create policy "tasks_delete_scoped" on public.tasks
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or assigned_to = auth.uid()
    or assigned_to is null
  );

-- notes: has no assigned_to of its own, so a sales_executive's write access
-- is derived from the assignment of the contact or project the note is
-- attached to.
create policy "notes_select_all" on public.notes
  for select to authenticated
  using (true);

create policy "notes_insert_scoped" on public.notes
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or exists (
      select 1 from public.contacts c
      where c.id = notes.contact_id
        and (c.assigned_to = auth.uid() or c.assigned_to is null)
    )
    or exists (
      select 1 from public.projects p
      where p.id = notes.project_id
        and (p.assigned_to = auth.uid() or p.assigned_to is null)
    )
  );

create policy "notes_update_scoped" on public.notes
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or exists (
      select 1 from public.contacts c
      where c.id = notes.contact_id
        and (c.assigned_to = auth.uid() or c.assigned_to is null)
    )
    or exists (
      select 1 from public.projects p
      where p.id = notes.project_id
        and (p.assigned_to = auth.uid() or p.assigned_to is null)
    )
  )
  with check (
    public.current_user_role() in ('admin', 'sales_manager')
    or exists (
      select 1 from public.contacts c
      where c.id = notes.contact_id
        and (c.assigned_to = auth.uid() or c.assigned_to is null)
    )
    or exists (
      select 1 from public.projects p
      where p.id = notes.project_id
        and (p.assigned_to = auth.uid() or p.assigned_to is null)
    )
  );

create policy "notes_delete_scoped" on public.notes
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'sales_manager')
    or exists (
      select 1 from public.contacts c
      where c.id = notes.contact_id
        and (c.assigned_to = auth.uid() or c.assigned_to is null)
    )
    or exists (
      select 1 from public.projects p
      where p.id = notes.project_id
        and (p.assigned_to = auth.uid() or p.assigned_to is null)
    )
  );

-- activity_log: admin/sales_manager have full read/write, as specified.
-- sales_executive is not granted write access here (not listed in the
-- requirements) — the app should write these rows via a service-role
-- context, which bypasses RLS entirely. sales_executive still gets the
-- same blanket read access as everyone else.
create policy "activity_log_select_all" on public.activity_log
  for select to authenticated
  using (true);

create policy "activity_log_insert_admin_manager" on public.activity_log
  for insert to authenticated
  with check (public.current_user_role() in ('admin', 'sales_manager'));

create policy "activity_log_update_admin_manager" on public.activity_log
  for update to authenticated
  using (public.current_user_role() in ('admin', 'sales_manager'))
  with check (public.current_user_role() in ('admin', 'sales_manager'));

create policy "activity_log_delete_admin_manager" on public.activity_log
  for delete to authenticated
  using (public.current_user_role() in ('admin', 'sales_manager'));
