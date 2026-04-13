variable "name" {
  description = "Front Door profile name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sku_name" {
  description = "Front Door SKU (Standard_AzureFrontDoor or Premium_AzureFrontDoor)"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "endpoint_name" {
  description = "Front Door endpoint name"
  type        = string
}

variable "origin_groups" {
  description = "Map of origin groups"
  type = map(object({
    sample_size                 = optional(number, 4)
    successful_samples_required = optional(number, 3)
    health_probe_path           = optional(string)
    health_probe_interval       = optional(number, 100)
  }))
}

variable "origins" {
  description = "Map of origins"
  type = map(object({
    origin_group_key               = string
    host_name                      = string
    origin_host_header             = optional(string)
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
    certificate_name_check_enabled = optional(bool, true)
    enabled                        = optional(bool, true)
  }))
}

variable "routes" {
  description = "Map of routes"
  type = map(object({
    origin_group_key       = string
    origin_keys            = list(string)
    patterns_to_match      = list(string)
    supported_protocols    = optional(list(string), ["Http", "Https"])
    https_redirect_enabled = optional(bool, true)
    forwarding_protocol    = optional(string, "HttpsOnly")
    rule_set_key           = optional(string)
  }))
}

variable "enable_spa_rewrite" {
  description = "Enable SPA URL rewrite rule set for client-side routing"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
