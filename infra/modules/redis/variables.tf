variable "name" {
  description = "Redis Cache name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "Redis SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "capacity" {
  description = "Redis cache capacity (0-6 for Basic/Standard, 1-5 for Premium)"
  type        = number
  default     = 0
}

variable "family" {
  description = "Redis cache family (C for Basic/Standard, P for Premium)"
  type        = string
  default     = "C"
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
