-- Enable RLS (Row Level Security)
alter table videos enable row level security;
alter table tag_groups enable row level security;
alter table profiles enable row level security;

-- Videos policies
create policy "Videos are viewable by everyone"
  on videos for select
  using (true);

create policy "Authenticated users can insert videos"
  on videos for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their own videos"
  on videos for update
  using (auth.uid() = user_id);

create policy "Users can delete their own videos"
  on videos for delete
  using (auth.uid() = user_id);

-- Tag groups policies
create policy "Tag groups are viewable by everyone"
  on tag_groups for select
  using (true);

create policy "Authenticated users can insert tag groups"
  on tag_groups for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their own tag groups"
  on tag_groups for update
  using (auth.uid() = user_id);

create policy "Users can delete their own tag groups"
  on tag_groups for delete
  using (auth.uid() = user_id);

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on profiles for select
  using (true);

create policy "Users can insert their own profile"
  on profiles for insert
  with check (auth.uid() = id);

create policy "Users can update their own profile"
  on profiles for update
  using (auth.uid() = id);

create policy "Users can delete their own profile"
  on profiles for delete
  using (auth.uid() = id);

-- Create required tables if they don't exist
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  username text unique,
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table if not exists public.videos (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  title text not null,
  description text,
  youtube_id text not null,
  category text not null,
  tags jsonb default '{}'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table if not exists public.tag_groups (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  name text not null,
  tags text[] default array[]::text[],
  category text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create indexes for better performance
create index if not exists videos_user_id_idx on videos(user_id);
create index if not exists videos_category_idx on videos(category);
create index if not exists tag_groups_user_id_idx on tag_groups(user_id);
create index if not exists tag_groups_category_idx on tag_groups(category);

-- Handle updated_at timestamps
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Create triggers for updated_at
create trigger on_profiles_updated
  before update on profiles
  for each row
  execute procedure handle_updated_at();

create trigger on_videos_updated
  before update on videos
  for each row
  execute procedure handle_updated_at();

create trigger on_tag_groups_updated
  before update on tag_groups
  for each row
  execute procedure handle_updated_at();

-- Create function to handle new user profiles
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data->>'username');
  return new;
end;
$$;

-- Create trigger for new users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();