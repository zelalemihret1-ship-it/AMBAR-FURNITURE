# AMBAR Furniture V2 — Start Here

## Purpose
This is the consolidated, isolated V2 development source based on the supplied AMBAR Furniture Mini App. It is intended for a NEW Telegram bot and a NEW Supabase staging project. It is not a production deployment package.

## Production safety
- Do not replace the current production bot with this package.
- Do not point staging at the production Supabase project.
- Do not reuse production bot tokens, database keys, payment credentials, or customer data.
- Keep all credentials in the staging host's secret manager, never in HTML, source control, or chat.

## Included V2 changes
- Main Admin customer-favorites report endpoint and Admin report screen. The report describes current saved favorites; it does not yet provide a historical add/remove event stream.
- Finance reporting period choices: daily, weekly, monthly, yearly; weekly is the configured default.
- Validated defaults for finance period and customer catalogue sorting in the existing interface settings object.
- SQL storage foundations for approval requests and customer/settings data.
- V2 isolation and implementation documentation.

## Important: not yet complete
The approval migration is only a queue schema. It does NOT by itself protect business operations. Every backend mutation must be routed through a server-side approval service before pending requests can affect official data. Main Admin approval must be enforced server-side, self-approval denied, and execution atomic/idempotent.

The supplied original project references legacy SQL migrations that are not included in the uploaded source archive. See `V2-INTEGRATION-GAP-REGISTER.md`. Do not guess their schemas or apply the V2 migrations to production.

No Telegram bot, Supabase project, hosting environment, payment provider, or live integration was connected by preparing this archive. Runtime integration tests require the separate staging environment and credentials.

## Safe setup order
1. Create a new Telegram bot in BotFather.
2. Create a new Supabase staging project.
3. Reconstruct and review the missing baseline migrations using the actual application schema and any historical project backups.
4. Apply reviewed migrations to staging only.
5. Configure staging-only secrets: `BOT_TOKEN`, `WEBAPP_URL`, `SUPABASE_URL`, `SUPABASE_SECRET_KEY` (or service-role key), `ADMIN_TELEGRAM_IDS`, and other sandbox credentials if applicable.
6. Deploy this source to a separate staging host.
7. Run the full test plan in `V2-INTEGRATION-GAP-REGISTER.md`.
8. Obtain owner approval before any production cutover.

## Suggested operator experience
Use one primary navigation structure: Dashboard, Orders, Workshop, Inventory, Finance, Customers, Reports, Settings. Keep specialist workflow pages available from their relevant workspace rather than duplicating navigation entries. Hide a feature only after confirming no route, permission, or business process depends on it.
