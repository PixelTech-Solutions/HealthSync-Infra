output "id" {
  description = "Cosmos DB account ID"
  value       = azurerm_cosmosdb_account.this.id
}

output "endpoint" {
  description = "Cosmos DB endpoint URI"
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "Cosmos DB primary key"
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "connection_strings" {
  description = "Cosmos DB connection strings"
  value       = azurerm_cosmosdb_account.this.connection_strings
  sensitive   = true
}

output "name" {
  description = "Cosmos DB account name"
  value       = azurerm_cosmosdb_account.this.name
}
