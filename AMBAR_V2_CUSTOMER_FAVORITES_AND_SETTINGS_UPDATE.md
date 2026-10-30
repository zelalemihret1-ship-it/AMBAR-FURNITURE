# AMBAR Furniture V2 — Customer Favorites & Settings Update

## Included changes

### Customer Favorites Report
- Adds a Main Admin-only endpoint: `GET /api/admin/customer-favorites-report`.
- Reads current saved favorites from `customer_app_state`.
- Enriches favorites with product catalogue details: product ID, name, category, price, description, specifications, stock status, active status and image URL when available.
- Enriches customers with available CRM profile details: customer ID, name, Telegram username/ID, phone, location, customer type and status.
- Includes aggregate favorite counts and most-favorited products.
- Adds a Customer Favorites Report section to the admin menu.
- Adds customer search, per-customer favorite details and CSV export.
- If a customer profile or product row is unavailable, the report still shows the saved Telegram ID/product ID and clearly marks missing details.

**Scope limitation:** the report reflects each customer's currently saved favorites. It is not a historical event log of every favorite being added or removed. `updated_at` belongs to the shared cart/favorites state row and can also change when cart data syncs.

### Centralized Settings & Default Values
- Extends the existing Main Admin-only Interface Designer settings object with validated defaults.
- Adds a default Finance reporting period (Daily / Weekly / Monthly / Yearly), defaulting to Weekly.
- Adds a default product catalogue sort order (Featured / Newest / Price low-to-high / Price high-to-low).
- Connects the finance period default to `financial-inventory.html`.
- Connects the catalogue sort default to the customer Mini App.
- Keeps the existing supported editable appearance, copy, translations, element presentation, visibility and section-order settings.
- Adds Customer Favorites Report to the editable Admin Menu Button Manager.

### Database migration
Apply `ambar_v2_customer_favorites_settings_migration.sql` to the separate V2 staging Supabase project only. It creates/reconciles:
- `customer_app_state`
- `ambar_interface_settings`
- `ambar_admin_button_settings`

RLS is enabled without public browser policies. The Flask backend accesses these tables using its server-side staging service-role credential after checking Telegram identity and admin authorization.

## Required staging setup
1. Create the separate V2 Supabase project.
2. Apply the SQL migration in that staging project.
3. Deploy the updated `bot.py`, `admin.html`, `index.html` and `financial-inventory.html` to the V2 staging host.
4. Configure only V2 staging secrets and the new V2 Telegram bot.
5. Test favorites sync using at least two Telegram test accounts; add/remove favorites and verify the report refreshes.
6. Test profile matching using a CRM profile with the same Telegram user ID.
7. Test products with and without photos/specifications and confirm missing product details are clearly shown.
8. Test CSV export, search, Main Admin access, and denial for non-Main-Admin accounts.
9. Publish the weekly finance default and confirm the finance dashboard opens with Weekly selected; change it and verify the new default is respected.
10. Change the product sort default and verify the customer catalogue order.

## Security and deployment notes
- The favorites report is restricted to Main Admin accounts.
- Customer favorites are not exposed through the public interface-settings endpoint.
- Never put Supabase service-role/secret keys or Telegram bot tokens in HTML or chat.
- Do not deploy this package to the live bot or production database until staging tests pass and the owner explicitly approves cutover.
- No production bot or production database was accessed or modified while preparing this update.

## Validation performed for this package
- `python -m py_compile bot.py`: passed.
- Node syntax checks for embedded scripts in `admin.html`, `index.html`, and `financial-inventory.html`: passed.
- Runtime Flask/Supabase integration tests were not run in this environment because Flask is not installed and no staging credentials/database are connected.
