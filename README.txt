AMBAR FURNITURE — WHITE EDITION COMPLETE PROJECT
================================================

This package refreshes the AMBAR customer Mini App into a clean, white, warm-neutral furniture storefront. The visual direction is inspired by the spacious editorial presentation used by modern furniture retailers such as Urban Ladder; it does not copy their logo, assets, or exact interface.

FILES INCLUDED
--------------
index.html              Customer Mini App (existing customer features retained; white theme applied)
bot.py                  Flask + Telegram backend, with Render environment-name compatibility
admin.html              Admin dashboard (product editor, order tracking, delivery, sales, customers, roles, security, button editor)
workshop-admin.html     Workshop ERP page (work orders, production, finished stock, materials, sales archive, reports, admin/staff controls)
financial-inventory.html Financial & Inventory dashboard (overview, transactions, reports, workshop sales, inventory/materials)
requirements.txt        Python dependencies
Procfile                Gunicorn start command (optional; Render may use the existing Start Command)
render.yaml             Example Render web-service configuration
products/               Placeholder folder for existing local product assets

IMPORTANT FEATURE / DATA NOTES
------------------------------
- The customer index is taken from the latest available AMBAR_index_no_first_signin.html and keeps its existing JavaScript and customer workflows; the change is visual styling, not a rewrite of order, payment, profile, tracking, or product logic.
- The admin page embeds its own Workshop ERP interface. The separate workshop-admin.html is also provided for the backend /workshop-admin and /workshop-erp routes.
- The finance dashboard remains permission-controlled by the backend.
- The backend uses Supabase REST. DATABASE_URL and SUPABASE_ANON_KEY are accepted as environment settings for compatibility, but this backend does not open a direct DATABASE_URL SQL connection or expose the anon key in the browser.
- Keep any existing product photo folder, custom fonts, app icon, SQL migrations, and other assets from your current repository. They were not all present in the files available for this package. Do not delete them.
- This ZIP does not contain live secrets, database records, or SQL migrations. Existing Supabase schema and migrations must remain in your Supabase project.

RENDER ENVIRONMENT VARIABLES
----------------------------
The backend accepts the names you supplied:
ADMIN_EMERGENCY_PAS (legacy/truncated alias; ADMIN_EMERGENCY_PASSWORD is preferred)
ADMIN_PASSWORD (fallback alias for emergency admin password)
ADMIN_PASSWORD_MANAGER_TELEGRAM_ID
AMBAR_V2_SUPABASE_SERVICE_ROLE_KEY
AMBAR_V2_SUPABASE_URL
BOT_TOKEN
DATABASE_URL (accepted but not directly used by this Supabase-REST backend)
FLASK_ENV
SECRET_KEY
SERVICE_CHAT_ID
SERVICE_ROLE_KEY
SUPABASE_ANON_KEY
SUPABASE_URL
TELEGRAM_BOT_TOKEN

Also retain any existing variables your deployment already uses, especially:
WEBAPP_URL, ADMIN_TELEGRAM_IDS, SUPABASE_SECRET_KEY, SUPABASE_SERVICE_ROLE_KEY,
CHAPA_SECRET_KEY, CHAPA_WEBHOOK_SECRET, CHAPA_API_BASE, BOT_PUBLIC_USERNAME,
SUPABASE_PRODUCTS_TABLE, SUPABASE_STORAGE_BUCKET, and UPLOAD_DIR.

BOT TOKEN PRECEDENCE
--------------------
BOT_TOKEN, then TELEGRAM_BOT_TOKEN, then AMBAR_V2_BOT_TOKEN. If both BOT_TOKEN and TELEGRAM_BOT_TOKEN exist, BOT_TOKEN is used. Ensure they refer to the same launching bot (@ambar_salesbot) to avoid Telegram HMAC mismatch.

SUPABASE KEY PRECEDENCE
-----------------------
AMBAR_V2_SUPABASE_URL then SUPABASE_URL.
AMBAR_V2_SUPABASE_SERVICE_ROLE_KEY then SERVICE_ROLE_KEY then SUPABASE_SERVICE_ROLE_KEY.
SUPABASE_SECRET_KEY remains supported as the legacy server secret. Never place a service-role key in index.html or any browser file.

DEPLOY SAFELY — DO NOT OVERWRITE YOUR WHOLE REPOSITORY BLINDLY
--------------------------------------------------------------
1. Download and unzip this package.
2. Back up your current GitHub repository and Supabase project first.
3. Compare and replace the matching files in your existing repository: bot.py, index.html, admin.html, workshop-admin.html, financial-inventory.html, requirements.txt. Keep all other existing folders/files, especially migrations, product photos, app icons, fonts, and config files.
4. In Render, preserve your existing service and environment values. Confirm WEBAPP_URL is the exact live URL configured in @ambar_salesbot.
5. Use the existing Render start command if it already works. Otherwise set it to: python bot.py
6. Deploy and wait for /health to respond successfully.
7. Test in Telegram: sign-in/profile, catalogue and product photos, cart, checkout, Chapa/Pay Later, order submission, My Orders refresh, cancellation, and Amharic.
8. Test Admin separately: product editing, order status, delivery settings, Sales Dashboard, staff roles, and security reports.
9. Test Workshop ERP and Financial & Inventory dashboard with authorized admin accounts.

DO NOT expose any bot token, admin password, Supabase service-role key, or Chapa secret in screenshots or browser code.
