# AMBAR Furniture V2 — Isolated Upgrade Plan

## Safety decisions
- Production Telegram bot: unchanged.
- Production Supabase project: unchanged and never used by staging.
- V2 source: isolated copy of the uploaded project baseline.
- V2 Telegram bot: create a separate bot with BotFather.
- V2 database: create a separate Supabase project and apply only reviewed V2 migrations.
- Promotion to production: explicit owner approval after acceptance tests and a tested rollback plan.

## Baseline inventory
The uploaded application includes:
- `bot.py` — Flask API, Telegram integration, Supabase REST access, authentication/authorization, orders and workshop endpoints.
- `index.html` — customer Mini App.
- `admin.html` — store administration.
- `workshop-admin.html`, `workshop-erp.html`, `workshop-customers.html` — workshop operations.
- `workflow.html`, `workflow-roles.html`, `process-workflows.html` — workflow and role interfaces.
- `financial-inventory.html` — finance and inventory interface.
- `README.txt`, `requirements.txt`, icon asset and update notes.

## Known integration dependencies to resolve
The source README references SQL migrations such as `phase2_orders_delivery_schema.sql` and `product_specifications_schema.sql`, but no `.sql` files are present in the uploaded archive. The code also references tables including:
- `customer_orders`
- `delivery_settings`, `delivery_areas`
- `customer_app_state`, `customer_service_settings`
- `ambar_interface_settings`, `ambar_admin_button_settings`
- `ambar_admin_roles`, `admin_emergency_password`, `admin_security_events`
- `workshop_erp_state`, `ambar_finance_entries`
- `worker_order_dispatches`, `customer_profiles`
- product table configured by `SUPABASE_PRODUCTS_TABLE` (default `products`)

Do not create a staging schema by guessing column definitions. Reconstruct migrations from the source code, historical migrations if available, and a reviewed schema inventory. Validate constraints, indexes, triggers, RLS policies, grants and foreign keys before applying.

## V2 workstreams
1. **Discovery and baseline:** map every route, page, table, role, permission, state transition and external integration.
2. **Information architecture:** consolidate navigation into Customer, Orders, Workshop, Inventory, Finance, Customers, Reports and Settings.
3. **Design system:** responsive layout, consistent typography/spacing, accessible contrast, reusable forms/tables/statuses, clear empty/error/loading states.
4. **Workflow engine:** explicit stages, owners, required inputs, validation, timestamps, audit trail, permitted transitions and exception handling.
5. **Application Designer:** editable copy, translations, labels, navigation, safe button visibility/order, themes, form configuration and workflow templates; draft/preview/publish/version/rollback.
6. **Operational correctness:** server-side validation, authorization on every mutation, idempotency, transaction boundaries, audit logs, data integrity and recoverable errors.
7. **Reports and exports:** reconcile dashboard totals with source records; timezone and ETB formatting; bounded pagination and export controls.
8. **Testing and deployment:** unit, integration, browser, Telegram, permission, migration, backup/restore, load and regression tests.

## Editability boundaries
Editable through the control center: interface text, translations, help text, menu labels/order/visibility, non-critical defaults, theme tokens, form presentation, notification templates, report presentation and workflow templates within validated rules.

Not arbitrary-editable: authentication, authorization enforcement, payment verification, financial arithmetic, stock ledger invariants, order identity, audit history, database constraints and secret configuration. These require code review or tightly validated configuration so an editor cannot make the business system unsafe or inconsistent.

## Staging-only environment variables
Set these in the staging host's secret manager, never in source control or chat:
- `BOT_TOKEN` — token for the NEW V2 bot only.
- `WEBAPP_URL` — V2 staging URL.
- `SUPABASE_URL` — URL of the NEW staging Supabase project.
- `SUPABASE_SECRET_KEY` or `SUPABASE_SERVICE_ROLE_KEY` — staging-only server secret.
- `ADMIN_TELEGRAM_IDS` — approved test administrators.
- `REQUIRE_TELEGRAM_AUTH=true`.
- Payment provider credentials: use sandbox/test credentials only, if payment integration is included in staging.
- Any other integration credentials must also be staging/test credentials.

Never reuse production secrets in staging. Never expose Supabase service-role/secret keys in HTML or browser JavaScript.

## Release gates
- [ ] New Telegram bot created and tested independently.
- [ ] Separate Supabase project created; project identity verified before migrations.
- [ ] Complete schema and migration set reviewed; no production database URL/key present.
- [ ] Test data only; no live customer data copied without an approved, minimized migration plan.
- [ ] Authentication, roles and every permission tested, including denied access.
- [ ] Order-to-workshop-to-delivery workflow tested end to end.
- [ ] Stock movements and finance reports reconcile against source transactions.
- [ ] Backup and restore tested on staging.
- [ ] Browser/mobile/Telegram Mini App regression suite passes.
- [ ] Rollback package and production cutover plan reviewed.
- [ ] Owner explicitly approves promotion to the main bot.

## Current validation performed on uploaded baseline
- Python syntax compilation of `bot.py`: passed.
- Node syntax checks for embedded JavaScript in all HTML files: passed.
- SQL migration files in the supplied archive: none found.

These are syntax checks only; they do not establish runtime correctness, security, schema compatibility or successful Telegram/Supabase integration.

## 2026-10-30 addendum — Customer Favorites & Settings
- Added Main Admin-only current customer favorites reporting, enriched from customer profiles and the product catalogue.
- Added searchable customer-by-customer favorite lists, popular product ranking and CSV export.
- Extended the validated Interface Designer defaults registry with weekly finance period and customer catalogue sorting.
- Added `ambar_v2_customer_favorites_settings_migration.sql` for staging customer state, interface settings and admin menu button settings.
- Scope note: current saved favorites are reported; favorite add/remove event history is not yet retained.
