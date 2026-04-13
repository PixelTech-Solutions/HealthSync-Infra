output "id" {
  description = "Redis Cache ID"
  value       = azurerm_redis_cache.this.id
}

output "hostname" {
  description = "Redis hostname"
  value       = azurerm_redis_cache.this.hostname
}

output "ssl_port" {
  description = "Redis SSL port"
  value       = azurerm_redis_cache.this.ssl_port
}

output "primary_access_key" {
  description = "Redis primary access key"
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Redis primary connection string"
  value       = azurerm_redis_cache.this.primary_connection_string
  sensitive   = true
}

output "name" {
  description = "Redis Cache name"
  value       = azurerm_redis_cache.this.name
}
