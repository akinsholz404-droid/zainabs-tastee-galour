-- Zainab's Tastee Galour — database setup
-- Customers can only PLACE orders. Only the admin (signed in through Supabase Auth)
-- can read, update or delete them. The menu is public to read, admin-only to change.

create extension if not exists pgcrypto;

-- ---------- Admins ----------
create table if not exists public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admins enable row level security;   -- no policies: not reachable through the API

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon, authenticated;

-- ---------- Orders ----------
create table if not exists public.orders (
  id            uuid primary key default gen_random_uuid(),
  ref           text not null unique check (char_length(ref) between 3 and 20),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  status        text not null default 'new'
                check (status in ('new','confirmed','preparing','out_for_delivery','ready_for_pickup','completed','cancelled')),
  customer_name text not null check (char_length(customer_name) between 1 and 80),
  phone         text not null check (char_length(phone) between 5 and 30),
  email         text check (email is null or char_length(email) <= 120),
  mode          text not null check (mode in ('delivery','pickup')),
  area          text check (area is null or char_length(area) <= 100),
  address       text check (address is null or char_length(address) <= 500),
  house         text check (house is null or char_length(house) <= 120),
  directions    text check (directions is null or char_length(directions) <= 500),
  map_url       text check (map_url is null or map_url ~ '^https://www\.google\.com/maps\?q=-?[0-9.]+,-?[0-9.]+$'),
  lat           double precision,
  lng           double precision,
  when_text     text check (when_text is null or char_length(when_text) <= 80),
  payment       text check (payment is null or char_length(payment) <= 80),
  notes         text check (notes is null or char_length(notes) <= 500),
  items         jsonb not null check (jsonb_typeof(items) = 'array' and jsonb_array_length(items) between 1 and 60),
  subtotal      numeric(10,3) not null check (subtotal >= 0 and subtotal < 10000),
  delivery_fee  numeric(10,3) not null default 0 check (delivery_fee >= 0 and delivery_fee < 1000),
  total         numeric(10,3) not null check (total >= 0 and total < 10000),
  currency      text not null default 'BHD' check (char_length(currency) <= 5),
  admin_note    text check (admin_note is null or char_length(admin_note) <= 1000)
);
create index if not exists orders_created_at_idx on public.orders (created_at desc);
create index if not exists orders_status_idx on public.orders (status);

create or replace function public.touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;
drop trigger if exists orders_touch on public.orders;
create trigger orders_touch before update on public.orders for each row execute function public.touch_updated_at();

alter table public.orders enable row level security;

drop policy if exists "customers place orders" on public.orders;
create policy "customers place orders" on public.orders
  for insert to anon, authenticated
  with check (status = 'new' and admin_note is null);

drop policy if exists "admin reads orders" on public.orders;
create policy "admin reads orders" on public.orders
  for select to authenticated using (public.is_admin());

drop policy if exists "admin updates orders" on public.orders;
create policy "admin updates orders" on public.orders
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "admin deletes orders" on public.orders;
create policy "admin deletes orders" on public.orders
  for delete to authenticated using (public.is_admin());

grant insert on public.orders to anon, authenticated;
grant select, update, delete on public.orders to authenticated;

-- ---------- Menu ----------
create table if not exists public.menu_items (
  id          text primary key check (id ~ '^[a-z0-9-]{2,60}$'),
  cat         text not null check (char_length(cat) between 1 and 40),
  name        text not null check (char_length(name) between 1 and 80),
  description text check (description is null or char_length(description) <= 300),
  price       numeric(10,3) not null check (price >= 0 and price < 1000),
  art         text,
  badge       text check (badge is null or char_length(badge) <= 30),
  featured    boolean not null default false,
  sold_out    boolean not null default false,
  hidden      boolean not null default false,
  img         text,
  sort        integer not null default 100,
  updated_at  timestamptz not null default now()
);
drop trigger if exists menu_touch on public.menu_items;
create trigger menu_touch before update on public.menu_items for each row execute function public.touch_updated_at();

alter table public.menu_items enable row level security;

drop policy if exists "anyone reads visible menu" on public.menu_items;
create policy "anyone reads visible menu" on public.menu_items
  for select to anon, authenticated using (hidden = false or public.is_admin());

drop policy if exists "admin manages menu" on public.menu_items;
create policy "admin manages menu" on public.menu_items
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

grant select on public.menu_items to anon, authenticated;
grant insert, update, delete on public.menu_items to authenticated;
