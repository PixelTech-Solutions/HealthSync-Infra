output "id" {
  description = "Storage Account ID"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.this.name
}

output "primary_web_host" {
  description = "Primary static website hostname"
  value       = azurerm_storage_account.this.primary_web_host
}

output "primary_web_endpoint" {
  description = "Primary static website endpoint URL"
  value       = azurerm_storage_account.this.primary_web_endpoint
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_connection_string" {
  description = "Storage Account primary connection string"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}
