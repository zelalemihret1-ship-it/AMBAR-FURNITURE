# AMBAR V2 Customer Session Repair

## What this repair changes

- Keeps both access methods: Telegram Mini App and independent browser website.
- Independent browser customer sessions are now permitted whenever `WEB_CUSTOMER_MODE=true`, even if `REQUIRE_TELEGRAM_AUTH=true` remains set in Render.
- Telegram requests that include `initData` must still pass Telegram HMAC validation. Invalid Telegram data is never downgraded to a browser guest.
- Browser customers receive customer-only access. This does not grant Main Admin, staff, finance, or Workshop permissions.
- Order/customer endpoints using `auth_result()` can now resolve the independent browser session.

## V2 Render settings

Set:

- `WEB_CUSTOMER_MODE=true`
- `SESSION_SIGNING_SECRET` to a long, private, stable random value
- Keep `BOT_TOKEN` set to the token for `@AMBAR_SALESBOT` for Telegram Mini App access
- `BOT_PUBLIC_USERNAME=AMBAR_SALESBOT`
- `WEBAPP_URL=https://ambar-furniture-dvit.onrender.com/`

`REQUIRE_TELEGRAM_AUTH` may remain `true`; it no longer blocks the separate browser customer session. Admin/staff routes still require their own Telegram identity and role checks.

## Verification

After deploying to the V2 service only:

1. Open `/api/health` and confirm `web_customer_mode` and `web_customer_auth_available` are `true`.
2. Open `/` in a normal browser. It should reach the customer confirmation screen, not the Telegram gate.
3. Open the Mini App from `@AMBAR_SALESBOT`; Telegram signed identity should still be validated.

This repair package was syntax-checked locally. It has not been deployed or tested against the live Render/Supabase environment. Do not deploy to production.
