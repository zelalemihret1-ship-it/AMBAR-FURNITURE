-- AMBAR Furniture V2: shared customer favorites state + centralized editable settings.
-- Apply ONLY to the separate AMBAR V2 staging Supabase project.
-- This migration does not read, copy, or alter the production database.

create table if not exists public.customer_app_state (
    telegram_user_id text primary key,
    cart jsonb not null default '{}'::jsonb,
    favorites jsonb not null default '[]'::jsonb,
    updated_at timestamptz not null default now(),
    constraint customer_app_state_cart_is_object check (jsonb_typeof(cart) = 'object'),
    constraint customer_app_state_favorites_is_array check (jsonb_typeof(favorites) = 'array')
);

create index if not exists customer_app_state_updated_at_idx
    on public.customer_app_state (updated_at desc);

create table if not exists public.ambar_interface_settings (
    id integer primary key default 1 check (id = 1),
    settings jsonb not null default '{}'::jsonb,
    version_history jsonb not null default '[]'::jsonb,
    updated_at timestamptz not null default now(),
    updated_by text,
    constraint ambar_interface_settings_settings_is_object check (jsonb_typeof(settings) = 'object'),
    constraint ambar_interface_settings_history_is_array check (jsonb_typeof(version_history) = 'array')
);

create table if not exists public.ambar_admin_button_settings (
    button_id text primary key,
    label text not null,
    visible boolean not null default true,
    disabled boolean not null default false,
    removed boolean not null default false,
    custom_url text,
    sort_order integer not null default 0,
    updated_at timestamptz not null default now()
);

create index if not exists ambar_admin_button_settings_sort_idx
    on public.ambar_admin_button_settings (sort_order, button_id);

-- The Flask server uses the staging project's server-side service-role key.
-- Keep RLS enabled so browser clients cannot read customer preferences or settings directly.
alter table public.customer_app_state enable row level security;
alter table public.ambar_interface_settings enable row level security;
alter table public.ambar_admin_button_settings enable row level security;

grant all on public.customer_app_state to service_role;
grant all on public.ambar_interface_settings to service_role;
grant all on public.ambar_admin_button_settings to service_role;

-- No anon/authenticated policies are created intentionally. The application API
-- validates Telegram identity and Main Admin authorization before exposing reports/settings.
