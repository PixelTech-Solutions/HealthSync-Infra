variable "name" {
  description = "Container App name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "container_app_environment_id" {
  description = "Container Apps Environment ID"
  type        = string
}

variable "identity_id" {
  description = "User-Assigned Managed Identity resource ID"
  type        = string
}

variable "registry_server" {
  description = "Container registry login server (e.g. myacr.azurecr.io)"
  type        = string
}

variable "container_name" {
  description = "Name of the container within the app"
  type        = string
}

variable "image_name" {
  description = "Container image name (without registry prefix)"
  type        = string
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "use_placeholder_image" {
  description = "Use a public placeholder image until real images are pushed to ACR"
  type        = bool
  default     = true
}

variable "cpu" {
  description = "CPU cores allocated to the container"
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memory allocated to the container (e.g. 0.5Gi)"
  type        = string
  default     = "0.5Gi"
}

variable "target_port" {
  description = "Port the container listens on"
  type        = number
}

variable "external_enabled" {
  description = "Whether ingress is externally accessible"
  type        = bool
  default     = false
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 3
}

variable "env_vars" {
  description = "Environment variables for the container"
  type = list(object({
    name        = string
    value       = optional(string)
    secret_name = optional(string)
  }))
  default = []
}

variable "secrets" {
  description = "Key Vault secret references for the container app"
  type = list(object({
    name                = string
    key_vault_secret_id = string
  }))
  default = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
