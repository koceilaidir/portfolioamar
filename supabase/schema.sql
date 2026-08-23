create table if not exists public.site_settings (
  id                       smallint primary key default 1 check (id = 1),

  role                     text not null default 'Web Designer',
  hero_title               text not null default 'Portfolio',
  greeting                 text not null default 'Hello, I''m',
  first_name               text not null default 'Amar',
  last_name                text not null default 'Hammour',
  subrole                  text not null default 'Web Designer & Digital Creative',
  lede                     text not null default '',
  signature                text not null default 'Amar Hammour',

  projects_title           text not null default 'Selected',
  projects_accent          text not null default 'Projects',
  projects_description     text,
  projects_link_label      text,

  skills_title             text not null default 'Skills &',
  skills_accent            text not null default 'Expertise',
  quote                    text not null default '',

  testimonials_title       text not null default 'What Clients',
  testimonials_accent      text not null default 'Say',
  testimonials_description text,

  contact_email            text not null default '',
  contact_website          text not null default '',
  contact_availability     text not null default '',
  contact_headline         text not null default 'Let''s create',
  contact_headline_accent  text not null default 'something great',
  contact_pitch            text not null default '',

  updated_at               timestamptz not null default now()
);

create table if not exists public.projects (
  id                   uuid primary key default gen_random_uuid(),
  title                text not null,
  subtitle             text not null default '',

  thumbnail_label      text not null default '',

  gradient_start       text not null default '#2B2B28',
  gradient_end         text not null default '#4A453D',
  thumbnail_text_color text not null default '#FFFFFF',

  image_path           text,
  url                  text,
  position             integer not null default 0,
  published            boolean not null default true,
  created_at           timestamptz not null default now()
);

create table if not exists public.skills (
  id         uuid primary key default gen_random_uuid(),
  label      text not null,
  level      integer not null default 80 check (level between 0 and 100),
  position   integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.features (
  id          uuid primary key default gen_random_uuid(),

  icon_key    text not null default 'star',
  title       text not null,
  description text not null default '',
  position    integer not null default 0,
  created_at  timestamptz not null default now()
);

create table if not exists public.testimonials (
  id          uuid primary key default gen_random_uuid(),
  quote       text not null check (char_length(quote) between 10 and 600),
  author      text not null check (char_length(author) between 2 and 80),
  author_role text not null default '' check (char_length(author_role) <= 120),
  email       text check (email is null or char_length(email) <= 160),
  status      text not null default 'pending'
                check (status in ('pending', 'approved', 'rejected')),
  position    integer not null default 0,
  created_at  timestamptz not null default now()
);

create index if not exists testimonials_status_idx on public.testimonials (status);
create index if not exists projects_position_idx  on public.projects (position);

alter table public.site_settings enable row level security;
alter table public.projects      enable row level security;
alter table public.skills        enable row level security;
alter table public.features      enable row level security;
alter table public.testimonials  enable row level security;

drop policy if exists "site_settings_public_read" on public.site_settings;
create policy "site_settings_public_read"
  on public.site_settings for select to anon, authenticated using (true);

drop policy if exists "projects_public_read" on public.projects;
create policy "projects_public_read"
  on public.projects for select to anon, authenticated using (published);

drop policy if exists "skills_public_read" on public.skills;
create policy "skills_public_read"
  on public.skills for select to anon, authenticated using (true);

drop policy if exists "features_public_read" on public.features;
create policy "features_public_read"
  on public.features for select to anon, authenticated using (true);

drop policy if exists "testimonials_public_read_approved" on public.testimonials;
create policy "testimonials_public_read_approved"
  on public.testimonials for select to anon, authenticated using (status = 'approved');

drop policy if exists "testimonials_public_insert_pending" on public.testimonials;
create policy "testimonials_public_insert_pending"
  on public.testimonials for insert to anon, authenticated with check (status = 'pending');

insert into storage.buckets (id, name, public)
values ('project-images', 'project-images', true)
on conflict (id) do update set public = true;

drop policy if exists "project_images_public_read" on storage.objects;
create policy "project_images_public_read"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'project-images');

insert into public.site_settings (
  id, role, hero_title, greeting, first_name, last_name, subrole, lede, signature,
  projects_title, projects_accent, projects_description, projects_link_label,
  skills_title, skills_accent, quote,
  testimonials_title, testimonials_accent, testimonials_description,
  contact_email, contact_website, contact_availability,
  contact_headline, contact_headline_accent, contact_pitch
) values (
  1,
  'Web Designer',
  'Portfolio',
  'Hello, I''m',
  'Amar',
  'Hammour',
  'Web Designer & Digital Creative',
  'Je conçois des visuels clairs, modernes et centrés sur l''utilisateur qui aident les marques à se démarquer.',
  'Amar Hammour',
  'Selected', 'Projects',
  'Une sélection de travaux récents mêlant design, développement et résolution de problèmes.',
  'Voir tous les projets',
  'Skills &', 'Expertise',
  'Je conçois et développe des expériences digitales qui ne sont pas seulement belles, mais aussi fonctionnelles, intuitives et marquantes.',
  'What Clients', 'Say',
  'Retours sincères de clients avec qui j''ai eu le plaisir de travailler.',
  'hello@amarhammour.design',
  'www.amarhammour.design',
  'Disponible en freelance',
  'Let''s create', 'something great',
  'Un projet en tête ? Construisons ensemble quelque chose qui a de l''impact.'
) on conflict (id) do nothing;

insert into public.projects (title, subtitle, thumbnail_label, gradient_start, gradient_end, thumbnail_text_color, position)
select * from (values
  ('Studio Form',      'Architecture Studio',   E'STUDIO\nFORM',    '#2B2B28', '#4A453D', '#FFFFFF', 1),
  ('Avenue & Co.',     'Luxury Fashion Brand',  'AVENUE & CO.',     '#CBB79C', '#7D6A52', '#FFFFFF', 2),
  ('The Journal',      'Editorial Platform',    'THE JOURNAL',      '#EFE9DE', '#C9C1B2', '#2B2B28', 3),
  ('Fuel Performance', 'Sports Nutrition Brand','FUEL PERFORMANCE', '#1C1C1A', '#3A352E', '#FFFFFF', 4)
) as seed
where not exists (select 1 from public.projects);

insert into public.skills (label, level, position)
select * from (values
  ('UI / UX Design',     95, 1),
  ('Web Development',    90, 2),
  ('Branding',           85, 3),
  ('Responsive Design',  90, 4),
  ('Interaction Design', 80, 5)
) as seed
where not exists (select 1 from public.skills);

insert into public.features (icon_key, title, description, position)
select * from (values
  ('user',        'User-Centered Design', 'Des expériences fluides et pensées pour l''utilisateur.', 1),
  ('code',        'Clean & Modern Code',  'Développement performant et évolutif.',                   2),
  ('responsive',  'Fully Responsive',     'Un rendu parfait sur tous les écrans.',                   3),
  ('performance', 'Performance Driven',   'Vitesse, SEO et bonnes pratiques intégrées.',             4)
) as seed
where not exists (select 1 from public.features);

insert into public.testimonials (quote, author, author_role, status, position)
select * from (values
  ('Amar est un designer incroyable. Il a parfaitement compris notre vision et livré un site qui a dépassé nos attentes.',
   'Jessica Lee', 'Founder, Avenue & Co.', 'approved', 1),
  ('Professionnel, créatif et minutieux. Tout le processus a été fluide du début à la fin.',
   'David Carter', 'CEO, Studio Form', 'approved', 2)
) as seed
where not exists (select 1 from public.testimonials);
