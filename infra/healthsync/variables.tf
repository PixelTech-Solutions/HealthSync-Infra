variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "healthsync"
}

# ── ACR ───────────────────────────────────────────────────────────────────────

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}

# ── Container Apps ────────────────────────────────────────────────────────────

variable "use_placeholder_image" {
  description = "Use a public placeholder image until real images are pushed to ACR. Set to false after CI/CD pushes images."
  type        = bool
  default     = true
}

# ── PostgreSQL ────────────────────────────────────────────────────────────────

variable "postgresql_location" {
  description = "Azure region for PostgreSQL (can differ from primary)"
  type        = string
  default     = "northeurope"
}

variable "postgresql_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "healthsyncadmin"
}

variable "postgresql_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "postgresql_sku" {
  description = "PostgreSQL SKU name"
  type        = string
  default     = "B_Standard_B1ms"
}

# ── Redis ─────────────────────────────────────────────────────────────────────

variable "redis_sku" {
  description = "Redis SKU name"
  type        = string
  default     = "Basic"
}

# ── Service Bus ───────────────────────────────────────────────────────────────

variable "servicebus_sku" {
  description = "Service Bus SKU"
  type        = string
  default     = "Basic"
}

# ── Secrets (sensitive — set via TF_VAR_* or GitHub Secrets) ──────────────────

variable "jwt_secret" {
  description = "JWT access token signing secret"
  type        = string
  sensitive   = true
}

variable "jwt_refresh_secret" {
  description = "JWT refresh token signing secret"
  type        = string
  sensitive   = true
}

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
}

variable "stripe_secret_key" {
  description = "Stripe API secret key"
  type        = string
  sensitive   = true
}

variable "stripe_publishable_key" {
  description = "Stripe publishable key"
  type        = string
}

# ── ACS ───────────────────────────────────────────────────────────────────────

variable "acs_data_location" {
  description = "Data location for Communication Services"
  type        = string
  default     = "United States"
}
