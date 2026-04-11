variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "healthsync"
}
variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "HealthSync-Dev-Chanidu"
}