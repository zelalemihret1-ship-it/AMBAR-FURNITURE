# AMBAR Furniture V2 — Finance periods and approval controls

## Implemented in this staging patch

- Finance period selector is now visible across the entire Financial & Inventory workspace.
- The selected period filters the Overview KPIs, money ledger, Workshop ERP sales, material movement history, CSV export, and PDF report.
- Period choices are Daily, Weekly, Monthly, and Yearly.
- Weekly is the default selection.
- Weeks run Monday through Sunday; months and years use calendar boundaries.
- Current on-hand inventory remains a current balance, not a historical period balance. The period selector filters dated inventory movements. Historical inventory snapshots can be used for true historical stock valuation when available.
- Monthly close is explicitly not represented as complete: a true close needs a separate approval-controlled period-close record, reconciliation, locked-period enforcement, and a reopen process.

## Required approval policy for V2

Every business-changing operation must be a request until the Main Admin approves it. Pending requests must not alter official records, balances, inventory quantities, order stages, payments, or customer-facing statuses.

The approval queue schema is provided in `ambar_v2_approval_workflow_migration.sql`. It is a storage foundation only. It does not by itself enforce approval. Before production use, server handlers must be updated so all mutating operations submit a request, and only the Main Admin approval endpoint can execute it.

### Operations that must be gated

- Workshop: work-order creation/edit, production-stage movement, completion, cancellation, deletion.
- Inventory: finished stock add/edit/sale/restock/delete; raw-material receipt, cut/use, adjustment, supplier and cost changes.
- Sales and finance: sale recording/edit, payment verification/refund, money-in/out, ledger correction/deletion, receivable settlement.
- Orders and delivery: order status changes, cancellation, dispatch, delivery fee changes and delivery confirmation.
- Purchasing: purchase requests, supplier bills and purchase payments.
- Administration: staff/role/permission changes, destructive reset, backup restore, system configuration changes.

Read-only operations, previews, reports and exports do not need movement approval, but should remain audited.

### Mandatory server-side approval safeguards

1. Verify Telegram identity and active role on every request.
2. Store requester, timestamp, operation type, summary, before-state, proposed change and an idempotency key.
3. Keep the official record unchanged while status is `pending`.
4. Only the configured Main Admin identity (and explicitly designated second super-admin if enabled) may approve or reject.
5. Prohibit self-approval; requester and approver IDs must differ.
6. Re-check permissions, business invariants and the original record version at approval time.
7. If the source changed after request creation, mark the request `conflict`; do not overwrite newer data.
8. Apply the change atomically and mark it approved/applied only after the write succeeds.
9. Record rejection reason, approver, decision time and immutable audit event.
10. Prevent duplicate execution on retries; approved requests cannot be executed twice.
11. Destructive actions require an explicit second confirmation from the Main Admin.
12. Main Admin-initiated changes also require an explicit confirmation step before committing.

## Staging deployment sequence

1. Create the separate V2 Supabase project and Telegram bot.
2. Apply the existing required project migrations after reviewing them, then apply `ambar_v2_approval_workflow_migration.sql`.
3. Implement and test approval endpoints and connect each write action to the approval queue.
4. Add the Main Admin approval inbox to the admin/workshop interface.
5. Test pending, approve, reject, self-approval denial, stale-record conflict, duplicate submission, and failed database writes.
6. Test finance period totals against source records for each period type.
7. Only after acceptance, prepare a controlled production migration and rollback plan.

## Safety statement

This patch does not connect to Supabase, does not create a Telegram bot, does not run SQL, and does not modify the live production service or database. The approval migration is not active until applied to staging and the server-side gates are deployed.
