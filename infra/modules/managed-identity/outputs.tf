output "id" {
  description = "Full resource ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Service principal ID associated with the identity"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.tenant_id
}
