# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Security (Key Vault + 16 Secrets)                             ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Key Vault ─────────────────────────────────────────────────────────────────

module "key_vault" {
  source                     = "../modules/key-vault"
  name                       = local.kv_name
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  tags                       = local.common_tags
}

# ── Key Vault Secrets ─────────────────────────────────────────────────────────
# All 16 secrets that match the actual Azure deployment

# --- Auth secrets (from variables — set via TF_VAR_*) ---

resource "azurerm_key_vault_secret" "jwt_secret" {
  name         = "jwt-secret"
  value        = var.jwt_secret
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "jwt_refresh_secret" {
  name         = "jwt-refresh-secret"
  value        = var.jwt_refresh_secret
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "google_client_id" {
  name         = "google-client-id"
  value        = var.google_client_id
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- Cosmos DB secrets (from module outputs) ---

resource "azurerm_key_vault_secret" "cosmos_connection" {
  name         = "cosmos-connection"
  value        = module.cosmos_db.primary_mongodb_connection_string
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "cosmos_key" {
  name         = "cosmos-key"
  value        = module.cosmos_db.primary_key
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "cosmos_uri_auth" {
  name         = "cosmos-uri-auth"
  value        = local.cosmos_db_uris["healthsync_auth"]
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "cosmos_uri_patients" {
  name         = "cosmos-uri-patients"
  value        = local.cosmos_db_uris["healthsync_patients"]
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "cosmos_uri_prescriptions" {
  name         = "cosmos-uri-prescriptions"
  value        = local.cosmos_db_uris["healthsync_prescriptions"]
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "cosmos_uri_notifications" {
  name         = "cosmos-uri-notifications"
  value        = local.cosmos_db_uris["healthsync_notifications"]
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- PostgreSQL secret ---

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = var.postgresql_admin_password
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- Redis secret ---

resource "azurerm_key_vault_secret" "redis_password" {
  name         = "redis-password"
  value        = module.redis.primary_access_key
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- Service Bus secret ---

resource "azurerm_key_vault_secret" "servicebus_connection_string" {
  name         = "servicebus-connection-string"
  value        = module.service_bus.primary_connection_string
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- Storage secret ---

resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "storage-connection-string"
  value        = module.storage_account.primary_connection_string
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- ACS Email secret ---

resource "azurerm_key_vault_secret" "acs_connection_string" {
  name         = "acs-connection-string"
  value        = module.communication_services.primary_connection_string
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

# --- Stripe secrets ---

resource "azurerm_key_vault_secret" "stripe_secret_key" {
  name         = "stripe-secret-key"
  value        = var.stripe_secret_key
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}

resource "azurerm_key_vault_secret" "stripe_publishable_key" {
  name         = "stripe-publishable-key"
  value        = var.stripe_publishable_key
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_officer]
}
