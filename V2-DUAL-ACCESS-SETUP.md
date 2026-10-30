# AMBAR Furniture V2 — Dual Access

This build supports two entry points to the same V2 storefront and backend:

1. **Telegram Mini App** — launched by the new `@AMBAR_SALESBOT` bot. Telegram `initData` is validated against the V2 `BOT_TOKEN`. If Telegram sends invalid signed data, the request is rejected; it is never downgraded to a browser guest.
2. **Independent web app** — opened directly at `https://ambar-furniture-dvit.onrender.com/` in a normal browser. It creates a signed, HTTP-only browser session and does not require Telegram or a Telegram token for customer browsing and customer actions.

Both modes use the same V2 Render service and separate V2 Supabase database. The production bot and production database must not be connected to this deployment.

## Render environment

Required for the independent web storefront:

- `WEB_CUSTOMER_MODE=true`
- `REQUIRE_TELEGRAM_AUTH=false`
- `SESSION_SIGNING_SECRET=<long random private value>`
- `SUPABASE_URL=<V2 project URL>`
- `SUPABASE_SECRET_KEY=<V2 server-side secret>`

Required for Telegram Mini App and bot notifications:

- `BOT_TOKEN=<token created for @AMBAR_SALESBOT>`
- `BOT_PUBLIC_USERNAME=AMBAR_SALESBOT`
- `WEBAPP_URL=https://ambar-furniture-dvit.onrender.com/`

The app can serve the independent website when `BOT_TOKEN` is absent, but Telegram launch and Telegram notifications will not work until the new bot token is set. When a token is set, startup checks that it belongs to `@AMBAR_SALESBOT` and configures the bot menu button.

Do not put tokens or Supabase secrets in GitHub, source files, or chat. Keep the production service and database unchanged.

## Deploy and verify

1. Deploy this project to the V2 GitHub/Render service only.
2. Open `/api/health`. Confirm `web_customer_mode: true`, `telegram_bot_optional: true`, and `access_modes` includes both modes. When `BOT_TOKEN` is configured, confirm `telegram_bot_identity_ok: true`.
3. Open the root URL in a normal browser. It should show the storefront without a Telegram gate.
4. Open the Mini App from `@AMBAR_SALESBOT`. It should authenticate using signed Telegram `initData`.
5. Test an order in V2 and confirm it appears in the V2 ERP.

## Security boundary

Browser sessions are customer sessions only; they do not grant Main Admin, staff, finance, or workshop permissions. Those roles remain protected by the existing staff/admin authorization mechanisms. A web guest cannot become an admin by changing browser-supplied IDs.

## Database

Use only the V2 Supabase project. Apply the SQL migrations in the deployment checklist. Never run them against production. This package does not claim to create missing ERP schemas listed in `V2-INTEGRATION-GAP-REGISTER.md`.
