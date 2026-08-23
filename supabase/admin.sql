create table if not exists public.admins (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;

drop policy if exists "admins_read_self" on public.admins;
create policy "admins_read_self"
  on public.admins for select to authenticated
  using (user_id = auth.uid());

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

drop policy if exists "site_settings_admin_write" on public.site_settings;
create policy "site_settings_admin_write"
  on public.site_settings for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "projects_admin_write" on public.projects;
create policy "projects_admin_write"
  on public.projects for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "skills_admin_write" on public.skills;
create policy "skills_admin_write"
  on public.skills for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "features_admin_write" on public.features;
create policy "features_admin_write"
  on public.features for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "testimonials_admin_write" on public.testimonials;
create policy "testimonials_admin_write"
  on public.testimonials for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "project_images_admin_write" on storage.objects;
create policy "project_images_admin_write"
  on storage.objects for all to authenticated
  using (bucket_id = 'project-images' and public.is_admin())
  with check (bucket_id = 'project-images' and public.is_admin());
