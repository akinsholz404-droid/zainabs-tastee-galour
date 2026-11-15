# Zainab's Tastee Galour — project notes for Claude

Ordering website for **Zainab's Tastee Galour**, a Nigerian snacks / small chops store
(prices in BHD, Bahrain). The owner is not a developer: explain things simply, step by step.

- **Live site:** https://zainabs-tastee-galour.vercel.app
- **Hosting:** Vercel (free Hobby plan, team "zainabs-tastee-galour"). Every push to `main`
  deploys automatically to the live link. No build step — it's a static site.
- **Repo:** github.com/akinsholz404-droid/zainabs-tastee-galour

## Files
- `index.html` — the whole site: HTML, CSS and JS in one file.
  - `STORE` settings block near the top of the script: WhatsApp number, prices/fees, hours,
    delivery areas, `orderEmailEndpoint`, `supabaseUrl`, `supabaseAnonKey`, `adminEmailDomain`.
  - `MENU` array = built-in fallback menu. When Supabase is configured, the menu loads from the
    `menu_items` table instead.
  - Food pictures are drawn SVG illustrations (`art()`); an item can use a real photo via `img`.
- `supabase/schema.sql` — tables `orders`, `menu_items`, `admins`, function `is_admin()`, and
  Row Level Security: customers can only INSERT orders; only admins can read/update/delete them;
  menu is public to read, admin-only to change.
- `supabase/seed_menu.sql` — starting menu rows.
- `gmail-order-emails.gs` is NOT in this repo (it was sent to the owner as a file): a Google Apps
  Script web app that emails order confirmations from the owner's Gmail. Its URL goes in
  `STORE.orderEmailEndpoint`.

## Features
- Menu with categories/search, cart, checkout (delivery or pickup), email field.
- Location: explains why, asks permission, auto-fills address (OpenStreetMap Nominatim reverse
  geocoding), then asks house/flat number (required) + driver instructions (optional).
- Review step: customer ticks "Yes, deliver to this address" before confirming.
- On confirm: order saved to Supabase + optional confirmation email; WhatsApp message as backup.
- **Admin tab:** link "Admin" in the footer (`#admin`). Supabase Auth login — username `admin`
  maps to `admin@zainabs-tastee-galour.app`. Orders (stats, filters, status, notes, delete,
  WhatsApp/email/map), Menu (edit price/name/sold out/hide/favourite, add, remove), Account
  (change password). Never hard-code passwords in the site — the repo and page are public.

## Status / to do
- [ ] Supabase: the owner connected the Supabase connector. Still needed: create a project
      (free), run `supabase/schema.sql` then `supabase/seed_menu.sql`, create the admin auth user
      (email above, password chosen by the owner — ask them; insert into `public.admins`),
      put the project URL + publishable/anon key into `STORE`, push, then test live
      (place an order, log in to Admin, change status).
- [ ] Owner to send real WhatsApp number, prices, pickup address, opening hours (placeholders now).
- [ ] Owner to set up the Gmail Apps Script and send its Web app URL.
- [ ] Owner to send real food photos.
- [ ] Remind the owner to change the admin password to something strong.
- Note: Vercel's Hobby plan is for non-commercial use; the owner chose it anyway. Netlify's free
  plan allows commercial use if they ever need to move.
