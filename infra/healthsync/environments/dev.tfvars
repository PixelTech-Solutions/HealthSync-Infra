# ║  HealthSync — Dev Environment                                               ║

environment  = "dev"
location     = "eastus"
project_name = "healthsync"

# ── ACR ───────────────────────────────────────────────────────────────────────
acr_sku = "Basic"

# ── PostgreSQL ────────────────────────────────────────────────────────────────
postgresql_location       = "northeurope"
postgresql_admin_username = "healthsyncadmin"
postgresql_sku            = "B_Standard_B1ms"
# postgresql_admin_password → set via TF_VAR_postgresql_admin_password

# ── Redis ─────────────────────────────────────────────────────────────────────
redis_sku = "Basic"

# ── Service Bus ───────────────────────────────────────────────────────────────
servicebus_sku = "Basic"

# ── Communication Services ────────────────────────────────────────────────────
acs_data_location = "United States"

# ── Container Apps ────────────────────────────────────────────────────────────
# Set to false after pushing real images to ACR
use_placeholder_image = true
