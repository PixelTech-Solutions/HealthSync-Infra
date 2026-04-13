output "id" {
  description = "Container Apps Environment ID"
  value       = azurerm_container_app_environment.this.id
}

output "default_domain" {
  description = "Default domain of the Container Apps Environment"
  value       = azurerm_container_app_environment.this.default_domain
}

output "static_ip_address" {
  description = "Static IP address of the Container Apps Environment"
  value       = azurerm_container_app_environment.this.static_ip_address
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.this.id
}
