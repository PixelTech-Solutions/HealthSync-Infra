output "id" {
  description = "Front Door profile ID"
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_hostname" {
  description = "Front Door endpoint hostname"
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "endpoint_id" {
  description = "Front Door endpoint ID"
  value       = azurerm_cdn_frontdoor_endpoint.this.id
}

output "profile_name" {
  description = "Front Door profile name"
  value       = azurerm_cdn_frontdoor_profile.this.name
}
