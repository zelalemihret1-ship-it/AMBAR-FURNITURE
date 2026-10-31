AMBAR FURNITURE - PREPARED BACKEND + MINI APP FILES

PACKAGE CONTENTS
- bot.py        AMBAR Workshop ERP backend, updated to accept the supplied Render variable names
- index.html    Latest available AMBAR customer Mini App HTML in the available project files
- requirements.txt  Python dependencies

RENDER START COMMAND
 gunicorn bot:app

ENVIRONMENT VARIABLES
The backend reads these names (where applicable):
- BOT_TOKEN (preferred), TELEGRAM_BOT_TOKEN, or AMBAR_V2_BOT_TOKEN
- SERVICE_CHAT_ID
- AMBAR_V2_SUPABASE_URL or SUPABASE_URL
- AMBAR_V2_SUPABASE_SERVICE_ROLE_KEY or SERVICE_ROLE_KEY (or legacy SUPABASE_SERVICE_ROLE_KEY)
- SUPABASE_SECRET_KEY (legacy-compatible Supabase API key fallback)
- ADMIN_PASSWORD_MANAGER_TELEGRAM_ID
- ADMIN_EMERGENCY_PAS (exact spelling supplied), ADMIN_EMERGENCY_PASSWORD, or ADMIN_PASSWORD
- SECRET_KEY
- SUPABASE_ANON_KEY, DATABASE_URL, and FLASK_ENV are read for configuration compatibility; this backend's current data layer uses Supabase REST, not DATABASE_URL.

SECURITY
- Never put BOT_TOKEN, Supabase service-role keys, emergency passwords, or SECRET_KEY in index.html.
- Keep Telegram authentication enabled. Do not publish secret values in screenshots or logs.
- Use the same bot token for the bot that launches the Mini App.
- Set WEBAPP_URL to the exact Render URL used by the live Mini App if it differs from the default.

IMPORTANT SCOPE NOTE
This is the complete set of files that could be assembled from the latest AMBAR files available in the conversation/library. The backend is the available 25-Oct Workshop ERP backend with environment-variable compatibility changes; the HTML is the latest available 31-Oct customer Mini App HTML. This package does not include unavailable SQL migration files, product image assets, or a full original Git repository. Do not overwrite your production project until you have backed it up and confirmed its required database migrations are applied.
