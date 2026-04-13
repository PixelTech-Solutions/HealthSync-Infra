# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Outputs                                                       ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Resource Group ────────────────────────────────────────────────────────────

output "resource_group_name" {
  value = module.resource_group.name
}

# ── Live URLs ─────────────────────────────────────────────────────────────────

output "frontend_url" {
  description = "Front Door CDN URL (production URL)"
  value       = "https://${module.front_door.endpoint_hostname}"
}

output "static_website_url" {
  description = "Static website direct URL (no CDN)"
  value       = module.storage_account.primary_web_endpoint
}

output "api_gateway_url" {
  description = "API Gateway Container App URL (direct)"
  value       = "https://${module.ca_api_gateway.latest_revision_fqdn}"
}

# ── Container Apps Environment ────────────────────────────────────────────────

output "cae_default_domain" {
  description = "Container Apps Environment default domain"
  value       = module.container_apps_environment.default_domain
}

# ── Container Registry ────────────────────────────────────────────────────────

output "acr_login_server" {
  description = "ACR login server"
  value       = module.container_registry.login_server
}

# ── Databases ─────────────────────────────────────────────────────────────────

output "cosmos_db_endpoint" {
  description = "Cosmos DB endpoint"
  value       = module.cosmos_db.endpoint
}

output "postgresql_fqdn" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = module.postgresql.fqdn
}

output "redis_hostname" {
  description = "Redis Cache hostname"
  value       = module.redis.hostname
}

# ── Key Vault ─────────────────────────────────────────────────────────────────

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.key_vault.vault_uri
}

# ── Managed Identity ──────────────────────────────────────────────────────────

output "managed_identity_client_id" {
  description = "User-Assigned Managed Identity client ID"
  value       = module.managed_identity.client_id
}

# ── Front Door ────────────────────────────────────────────────────────────────

output "front_door_endpoint" {
  description = "Front Door endpoint hostname"
  value       = module.front_door.endpoint_hostname
}

# ── Communication Services ────────────────────────────────────────────────────

output "acs_email_domain" {
  description = "ACS Azure-managed email domain"
  value       = module.communication_services.domain_name
}
