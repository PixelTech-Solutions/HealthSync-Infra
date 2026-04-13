variable "name" {
  description = "Service Bus namespace name"
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

variable "sku" {
  description = "Service Bus SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "queues" {
  description = "List of queue names to create"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
