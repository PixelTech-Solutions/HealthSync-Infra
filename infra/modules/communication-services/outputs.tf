output "id" {
  description = "Communication Services ID"
  value       = azurerm_communication_service.this.id
}

output "primary_connection_string" {
  description = "Communication Services primary connection string"
  value       = azurerm_communication_service.this.primary_connection_string
  sensitive   = true
}

output "email_service_id" {
  description = "Email Communication Services ID"
  value       = azurerm_email_communication_service.this.id
}

output "domain_name" {
  description = "Azure managed email domain name"
  value       = azurerm_email_communication_service_domain.this.from_sender_domain
}

output "sender_address" {
  description = "Full sender email address (DoNotReply@domain)"
  value       = "DoNotReply@${azurerm_email_communication_service_domain.this.from_sender_domain}"
}

output "name" {
  description = "Communication Services name"
  value       = azurerm_communication_service.this.name
}
