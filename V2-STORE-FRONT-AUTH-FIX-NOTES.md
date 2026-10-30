# AMBAR Furniture V2 — Storefront Refresh & Telegram Auth Patch

## Updated in this package
- Refreshed `index.html` with a warm, light furniture-shopping storefront inspired by the supplied reference: editorial hero, teal pill actions, rounded product cards, category chips, refined cart bar, and matching checkout surfaces.
- Kept the existing product catalogue, product detail, favorites, cart, custom order, customer profile, order tracking, checkout/payment, and ERP/admin entry points in place.
- Updated the default V2 `WEBAPP_URL` to `https://ambar-furniture-dvit.onrender.com/` (Render Environment values override this default).
- Hardened Telegram `initData` validation: rejects duplicate fields, excludes Telegram's optional `signature` parameter from the bot-token HMAC check, checks the signed user and auth timestamp, and logs safe reason codes without logging tokens or raw initData.
- Updated the customer gate link to `https://t.me/AMBAR_SALESBOT`.

## Deployment settings (V2 Render service only)
- `BOT_TOKEN`: token for the bot that launches this V2 Mini App.
- `BOT_PUBLIC_USERNAME`: `AMBAR_SALESBOT` (use the exact username shown by BotFather).
- `WEBAPP_URL`: `https://ambar-furniture-dvit.onrender.com/`.
- Keep `SUPABASE_URL` and its server-side key pointed at the separate V2 staging project.

## Important limits
- This package cannot change Render Environment values or Supabase schema by itself.
- The previous Render logs showed missing `public.products`, `public.ambar_interface_settings`, and `public.admin_security_events` tables. This ZIP does not invent a products schema or apply SQL migrations; those database errors still need the correct schema/migrations in the V2 Supabase project.
- Telegram authentication must be verified by opening the Mini App from the V2 bot after deploying this package. Static checks do not prove live Telegram authentication or database integration.
- Production bot/database are not included, contacted, or modified.
