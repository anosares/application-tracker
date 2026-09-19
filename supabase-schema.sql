-- Run this once in your Supabase project: Dashboard > SQL Editor > New query > Run.

create table if not exists applications (
  id uuid primary key default gen_random_uuid(),
  role text not null,
  platform text not null,
  applied_date date not null,
  status text not null default 'Applied',
  interviewed_date date,
  hired_date date,
  created_at timestamptz not null default now()
);

-- Row Level Security must be on before any policy takes effect.
alter table applications enable row level security;

-- These policies make the table fully readable and writable by anyone
-- holding your project's public "anon" key — which is exactly what the
-- app uses, since it's a personal single-user tracker with no login.
-- If you ever want to lock it down (e.g. add a login), replace these
-- with policies scoped to auth.uid() instead.
create policy "Public read access"   on applications for select using (true);
create policy "Public insert access" on applications for insert with check (true);
create policy "Public update access" on applications for update using (true);
create policy "Public delete access" on applications for delete using (true);

-- Needed so the app gets live updates across devices/tabs.
alter publication supabase_realtime add table applications;
