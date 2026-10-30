# AMBAR V2 — New Telegram bot authentication fix

This V2 code is locked to the new Telegram bot username `AMBAR_SALESBOT` by default.

## Required V2 Render settings
Set these on the V2 Render service only (never on the production service):

- `BOT_TOKEN`: the private BotFather token belonging to `@AMBAR_SALESBOT`.
- `BOT_PUBLIC_USERNAME`: `AMBAR_SALESBOT` (no `@`).
- `WEBAPP_URL`: `https://ambar-furniture-dvit.onrender.com/`.
- `REQUIRE_TELEGRAM_AUTH`: `true`.

Do not use the old production bot token. Do not paste tokens into GitHub or chat.

## What this repair changes
- At startup, the bot calls Telegram `getMe` and refuses to start its bot polling if `BOT_TOKEN` belongs to any username other than `@AMBAR_SALESBOT`.
- It configures the new bot's Telegram menu button to open the V2 Render URL.
- `/api/health` reports the expected and actual bot usernames plus a `telegram_bot_identity_ok` boolean. It never returns the token.
- Customer authentication continues to validate Telegram's signed `initData` using the V2 `BOT_TOKEN`.

## Verify after deploying
1. Open `https://ambar-furniture-dvit.onrender.com/api/health`.
2. Confirm `telegram_bot_identity_ok` is `true` and `telegram_actual_bot_username` is `AMBAR_SALESBOT`.
3. In Telegram, open `@AMBAR_SALESBOT`, press Start, then open the Mini App using its menu button.
4. Do not open the Render URL in an ordinary browser tab for Telegram sign-in.

If `telegram_bot_identity_ok` is false, update only the V2 Render `BOT_TOKEN` with the token for `@AMBAR_SALESBOT`, then redeploy. This is a bot-token configuration issue, not a customer account issue.
