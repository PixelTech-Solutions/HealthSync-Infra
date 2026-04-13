# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Foundation (Resource Group, Identity, ACR, Role Assignments)  ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Resource Group ────────────────────────────────────────────────────────────

module "resource_group" {
  source   = "../modules/resource-group"
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

# ── User-Assigned Managed Identity ────────────────────────────────────────────

module "managed_identity" {
  source              = "../modules/managed-identity"
  name                = local.id_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags
}

# ── Container Registry ────────────────────────────────────────────────────────

module "container_registry" {
  source              = "../modules/acr"
  name                = local.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = local.common_tags
}

# ── Role Assignments ──────────────────────────────────────────────────────────

# Managed Identity → Key Vault Secrets User
resource "azurerm_role_assignment" "identity_kv_secrets" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.managed_identity.principal_id
}

# Terraform deployer → Key Vault Secrets Officer (to manage secrets)
resource "azurerm_role_assignment" "deployer_kv_officer" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Managed Identity → ACR Pull (so Container Apps can pull images)
resource "azurerm_role_assignment" "identity_acr_pull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.managed_identity.principal_id
}