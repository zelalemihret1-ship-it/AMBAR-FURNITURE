# AMBAR Furniture V2 — Integration Gap Register & Acceptance Plan

This document distinguishes what is present in source from what must still be completed and verified. A syntax check is not proof of a connected or operational system.

## A. Confirmed source-level changes
- `bot.py`: Main Admin-only `GET /api/admin/customer-favorites-report` endpoint; reads current favorites, attempts to enrich them from customer profiles and product catalogue, returns customer and popular-product summaries.
- `admin.html`: customer favorites report UI, search, customer details and CSV export.
- `bot.py` / `admin.html`: favorites report menu integration.
- `bot.py`: validates `financePeriod` (daily/weekly/monthly/yearly; weekly fallback) and `productSort` settings.
- `financial-inventory.html` and `index.html`: connect those defaults to finance reporting and catalogue sorting.
- SQL files: approval queue storage and customer/settings storage foundations.

## B. Known missing prerequisites
The original README references these SQL migrations, but they were not present in the supplied original ZIP:
- `phase2_orders_delivery_schema.sql`
- `product_specifications_schema.sql`

The source also references migrations for interface settings, admin roles/security, customer profiles, finance entries, workshop state, staff passwords, and other features. Some migration filenames are mentioned in application code or README but are not included in the supplied archive. Recover the authoritative versions from the existing project repository, database migration history, or owner-provided backups. Do not invent column definitions.

The application references these Supabase tables at minimum:
- `customer_orders`
- `delivery_settings`, `delivery_areas`
- `customer_app_state`, `customer_service_settings`
- `ambar_interface_settings`, `ambar_admin_button_settings`
- `ambar_admin_roles`, `admin_emergency_password`, `admin_security_events`
- `workshop_erp_state`, `ambar_finance_entries`
- `worker_order_dispatches`, `customer_profiles`
- product table configured by `SUPABASE_PRODUCTS_TABLE` (default `products`)
- V2 addition: `ambar_approval_requests`

The actual columns, constraints, triggers, indexes, RLS policies, grants, and foreign keys must be reconciled against the staging database schema before deployment.

## C. Approval engine — mandatory implementation work
The approval queue table is not enforcement. Before any V2 business use, every write path must be inventoried and gated server-side. At minimum:
- orders: create/edit, status changes, cancellation, dispatch, delivery confirmation where it changes official state;
- workshop: work-order create/edit, assignment, stage movement, completion, cancellation;
- inventory: receipt, issue/use, adjustment, transfer, sale/restock, supplier/cost changes;
- finance: sale, expense, money-in/out, payment verification, refund, receivable settlement, ledger corrections;
- purchasing: purchase request, supplier invoice, payment;
- administration: staff/role/permission changes, configuration publication, destructive reset and restore.

Required behavior:
1. Pending requests do not change official balances, stock, order stages, or customer-facing completed statuses.
2. Verify Telegram identity and current permissions on every request.
3. Only the configured Main Admin can approve/reject; requester cannot approve their own request.
4. Store requester, request time, type, payload, before snapshot/version, idempotency key and evidence.
5. Re-check invariants and record version at approval time; stale requests become conflicts.
6. Apply business change and audit record atomically; duplicate retries cannot execute twice.
7. Rejected requests preserve original state and record the reason.
8. Main Admin-originated business changes still require an explicit confirmation step.
9. Destructive operations require an additional explicit confirmation.
10. Audit history is append-only to normal application users.

## D. Monthly close and correction policy
- Closing creates a dated reconciliation snapshot, not a permanent deletion or immutable lockout.
- Corrections to a closed period are submitted as adjustment requests.
- Main Admin approval is required before the adjustment affects official figures.
- Preserve original transaction and previous close snapshot; never overwrite history silently.
- Recalculate affected period reports after approval and retain who/when/why metadata.

## E. Customer favorites report limitations and next steps
Current report reads saved favorites state, not every favorite add/remove event over time. To provide full historical intelligence, add an append-only favorite-events table and server endpoint that records customer ID/Telegram ID, product ID, action (`added`/`removed`), event timestamp, and source. Add retention/privacy rules and report filters for date range, product/category, customer segment, and event type. Ensure customers can only mutate their own favorites; only Main Admin can view the full cross-customer report.

## F. Settings completeness and safe editability
The current settings changes extend selected defaults and an existing Interface Designer. They do not make every application feature editable. Complete the settings registry with:
- interface text/translations, menu labels/order/visibility, themes and safe presentation controls;
- defaults for validated operational choices and report periods;
- form fields and required/optional presentation;
- notification templates;
- workflow templates and allowed transitions within hard-coded business invariants;
- report presentation and export defaults;
- draft, preview, publish, version history and rollback.

Never expose arbitrary editing of authentication, authorization enforcement, financial arithmetic, stock ledger invariants, secrets, immutable audit records, or database constraints. Editable configuration must be validated and permission-controlled.

## G. Integration acceptance tests (must pass on staging)
1. New bot and staging URL work independently of production.
2. Telegram WebApp identity validation succeeds for authorized test users and rejects forged/missing identity.
3. Customer favorites add/remove persists per customer; two customers cannot see or alter each other's private state.
4. Main Admin favorites report joins real customer/product records, handles missing profile/product safely, filters/searches and exports accurate CSV.
5. Order created by customer appears exactly once in Admin, Finance/receivables and Workshop as appropriate.
6. Workshop material consumption changes stock only after approval and produces the correct ledger entry.
7. Sale/payment/expense changes affect finance totals only after approval.
8. Approval pending, approve, reject, self-approval denial, unauthorized approver denial, stale-version conflict, duplicate retry and failed-write rollback all pass.
9. Every module's dashboard totals reconcile to underlying transaction rows.
10. Daily/weekly/monthly/yearly report windows use the configured business timezone and reconcile with source data; week boundary is documented.
11. Monthly close snapshot and correction approval preserve prior values and complete audit history.
12. Settings draft/preview/publish/version rollback works; invalid defaults are rejected; non-admin users cannot publish.
13. Backup and restore pass using staging data; restore requires Main Admin confirmation and is audited.
14. Mobile, desktop and Telegram Mini App navigation, empty/loading/error states, accessibility and pagination are tested.
15. No staging secrets, URLs, or test callbacks point to production.

## H. Safe cleanup policy
- Removed Python bytecode/cache artifacts from the delivery archive.
- Did not delete existing HTML modules or backend routes merely because they appear similar; they may be referenced by navigation, permissions, or business workflows.
- Consolidate or remove duplicate screens only after route/reference and role regression tests prove they are unused.

## I. Validation performed for this consolidated archive
- Python syntax compilation of `bot.py`: passed.
- Node syntax checks for inline JavaScript in all HTML files: passed.
- Archive cleanup: Python cache artifacts excluded.
- Not performed: SQL execution, Flask/Supabase runtime tests, Telegram bot tests, browser end-to-end tests, financial reconciliation, approval enforcement tests, backup/restore tests. These require a configured isolated staging environment.
