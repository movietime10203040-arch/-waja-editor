-- Waja Editor Supabase setup
-- Run this in Supabase Dashboard > SQL Editor after creating a project.

create extension if not exists pgcrypto;

create table if not exists public.prompts (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 100),
  category text not null default 'Other',
  creator text not null default 'Waja Editor',
  prompt text not null check (char_length(prompt) between 1 and 15000),
  image_url text,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.prompts enable row level security;

drop policy if exists "Prompts are visible to everyone" on public.prompts;
create policy "Prompts are visible to everyone"
on public.prompts for select using (true);

drop policy if exists "Signed-in admins can add their own prompts" on public.prompts;
create policy "Signed-in admins can add their own prompts"
on public.prompts for insert to authenticated
with check (auth.uid() = created_by);

drop policy if exists "Authors can delete their own prompts" on public.prompts;
create policy "Authors can delete their own prompts"
on public.prompts for delete to authenticated
using (auth.uid() = created_by);

-- Storage bucket for prompt images
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('prompt-images', 'prompt-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = true, file_size_limit = 5242880;

drop policy if exists "Prompt images are public to read" on storage.objects;
create policy "Prompt images are public to read"
on storage.objects for select using (bucket_id = 'prompt-images');

drop policy if exists "Signed-in users can upload prompt images" on storage.objects;
create policy "Signed-in users can upload prompt images"
on storage.objects for insert to authenticated
with check (bucket_id = 'prompt-images');

drop policy if exists "Signed-in users can delete prompt images" on storage.objects;
create policy "Signed-in users can delete prompt images"
on storage.objects for delete to authenticated
using (bucket_id = 'prompt-images');
