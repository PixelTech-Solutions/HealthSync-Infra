output "id" {
  description = "Container App ID"
  value       = azurerm_container_app.this.id
}

output "name" {
  description = "Container App name"
  value       = azurerm_container_app.this.name
}

output "latest_revision_fqdn" {
  description = "FQDN of the latest revision"
  value       = azurerm_container_app.this.latest_revision_fqdn
}

output "outbound_ip_addresses" {
  description = "Outbound IP addresses"
  value       = azurerm_container_app.this.outbound_ip_addresses
}
