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
  value       = var.enable_static_website ? azurerm_storage_account_static_website.this[0].hostname : null
}

output "primary_web_endpoint" {
  description = "Primary static website endpoint URL"
  value       = var.enable_static_website ? "https://${azurerm_storage_account_static_website.this[0].hostname}/" : null
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
