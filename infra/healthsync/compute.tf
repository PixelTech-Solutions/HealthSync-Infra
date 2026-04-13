# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Compute (Container Apps Environment + 7 Container Apps)       ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Container Apps Environment + Log Analytics ────────────────────────────────

module "container_apps_environment" {
  source              = "../modules/container-apps-environment"
  name                = local.cae_name
  log_analytics_name  = local.law_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags
}

# ── Service Bus (messaging between services) ──────────────────────────────────
# Basic tier, 3 queues: appointment-events, prescription-events, doctor-events

module "service_bus" {
  source              = "../modules/service-bus"
  name                = local.sb_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.servicebus_sku
  queues              = local.servicebus_queues
  tags                = local.common_tags
}

# ═══════════════════════════════════════════════════════════════════════════════
#  CONTAINER APPS — 7 services
# ═══════════════════════════════════════════════════════════════════════════════

# ── 1. API Gateway (External — only public-facing service) ────────────────────

module "ca_api_gateway" {
  source                       = "../modules/container-app"
  name                         = "ca-api-gateway"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "api-gateway"
  image_name                   = "api-gateway"
  target_port                  = 8080
  external_enabled             = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "jwt-secret", key_vault_secret_id = azurerm_key_vault_secret.jwt_secret.versionless_id },
    { name = "jwt-refresh-secret", key_vault_secret_id = azurerm_key_vault_secret.jwt_refresh_secret.versionless_id },
    { name = "google-client-id", key_vault_secret_id = azurerm_key_vault_secret.google_client_id.versionless_id },
    { name = "cosmos-uri-auth", key_vault_secret_id = azurerm_key_vault_secret.cosmos_uri_auth.versionless_id },
    { name = "storage-connection-string", key_vault_secret_id = azurerm_key_vault_secret.storage_connection_string.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "8080" },
    { name = "NODE_ENV", value = "production" },
    { name = "JWT_SECRET", secret_name = "jwt-secret" },
    { name = "JWT_REFRESH_SECRET", secret_name = "jwt-refresh-secret" },
    { name = "GOOGLE_CLIENT_ID", secret_name = "google-client-id" },
    { name = "MONGO_URI", secret_name = "cosmos-uri-auth" },
    { name = "AZURE_STORAGE_CONNECTION_STRING", secret_name = "storage-connection-string" },
    { name = "AZURE_STORAGE_CONTAINER_NAME", value = "avatars" },
    { name = "PATIENT_SERVICE_URL", value = local.service_urls.patient },
    { name = "DOCTOR_SERVICE_URL", value = local.service_urls.doctor },
    { name = "APPOINTMENT_SERVICE_URL", value = local.service_urls.appointment },
    { name = "PRESCRIPTION_SERVICE_URL", value = local.service_urls.prescription },
    { name = "NOTIFICATION_SERVICE_URL", value = local.service_urls.notification },
    { name = "PAYMENT_SERVICE_URL", value = local.service_urls.payment },
    { name = "FRONTEND_URL", value = "https://${module.front_door.endpoint_hostname}" },
    { name = "STATIC_WEBSITE_URL", value = module.storage_account.primary_web_endpoint != null ? trimsuffix(module.storage_account.primary_web_endpoint, "/") : "" },
  ]
}

# ── 2. Doctor Service (Internal) ─────────────────────────────────────────────

module "ca_doctor_service" {
  source                       = "../modules/container-app"
  name                         = "ca-doctor-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "doctor-service"
  image_name                   = "doctor-service"
  target_port                  = 3002
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "postgres-password", key_vault_secret_id = azurerm_key_vault_secret.postgres_password.versionless_id },
    { name = "redis-password", key_vault_secret_id = azurerm_key_vault_secret.redis_password.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3002" },
    { name = "NODE_ENV", value = "production" },
    { name = "DB_HOST", value = module.postgresql.fqdn },
    { name = "DB_PORT", value = "5432" },
    { name = "DB_USER", value = var.postgresql_admin_username },
    { name = "DB_PASSWORD", secret_name = "postgres-password" },
    { name = "DB_NAME", value = "healthsync_doctors" },
    { name = "DB_SSL", value = "true" },
    { name = "REDIS_HOST", value = module.redis.hostname },
    { name = "REDIS_PORT", value = tostring(module.redis.ssl_port) },
    { name = "REDIS_PASSWORD", secret_name = "redis-password" },
  ]
}

# ── 3. Appointment Service (Internal) ────────────────────────────────────────

module "ca_appointment_service" {
  source                       = "../modules/container-app"
  name                         = "ca-appointment-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "appointment-service"
  image_name                   = "appointment-service"
  target_port                  = 3003
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "postgres-password", key_vault_secret_id = azurerm_key_vault_secret.postgres_password.versionless_id },
    { name = "servicebus-connection-string", key_vault_secret_id = azurerm_key_vault_secret.servicebus_connection_string.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3003" },
    { name = "NODE_ENV", value = "production" },
    { name = "DB_HOST", value = module.postgresql.fqdn },
    { name = "DB_PORT", value = "5432" },
    { name = "DB_USER", value = var.postgresql_admin_username },
    { name = "DB_PASSWORD", secret_name = "postgres-password" },
    { name = "DB_NAME", value = "healthsync_appointments" },
    { name = "DB_SSL", value = "true" },
    { name = "SERVICE_BUS_CONNECTION_STRING", secret_name = "servicebus-connection-string" },
  ]
}

# ── 4. Patient Service (Internal) ────────────────────────────────────────────

module "ca_patient_service" {
  source                       = "../modules/container-app"
  name                         = "ca-patient-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "patient-service"
  image_name                   = "patient-service"
  target_port                  = 3001
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "cosmos-uri-patients", key_vault_secret_id = azurerm_key_vault_secret.cosmos_uri_patients.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3001" },
    { name = "NODE_ENV", value = "production" },
    { name = "MONGO_URI", secret_name = "cosmos-uri-patients" },
  ]
}

# ── 5. Prescription Service (Internal) ───────────────────────────────────────

module "ca_prescription_service" {
  source                       = "../modules/container-app"
  name                         = "ca-prescription-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "prescription-service"
  image_name                   = "healthsync-prescription-service"
  target_port                  = 3004
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "cosmos-uri-prescriptions", key_vault_secret_id = azurerm_key_vault_secret.cosmos_uri_prescriptions.versionless_id },
    { name = "servicebus-connection-string", key_vault_secret_id = azurerm_key_vault_secret.servicebus_connection_string.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3004" },
    { name = "NODE_ENV", value = "production" },
    { name = "MONGO_URI", secret_name = "cosmos-uri-prescriptions" },
    { name = "SERVICE_BUS_CONNECTION_STRING", secret_name = "servicebus-connection-string" },
  ]
}

# ── 6. Payment Service (Internal) ────────────────────────────────────────────

module "ca_payment_service" {
  source                       = "../modules/container-app"
  name                         = "ca-payment-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "payment-service"
  image_name                   = "payment-service"
  target_port                  = 3006
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 0
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "postgres-password", key_vault_secret_id = azurerm_key_vault_secret.postgres_password.versionless_id },
    { name = "stripe-secret-key", key_vault_secret_id = azurerm_key_vault_secret.stripe_secret_key.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3006" },
    { name = "NODE_ENV", value = "production" },
    { name = "DB_HOST", value = module.postgresql.fqdn },
    { name = "DB_PORT", value = "5432" },
    { name = "DB_USER", value = var.postgresql_admin_username },
    { name = "DB_PASSWORD", secret_name = "postgres-password" },
    { name = "DB_NAME", value = "healthsync_payments" },
    { name = "DB_SSL", value = "true" },
    { name = "STRIPE_SECRET_KEY", secret_name = "stripe-secret-key" },
  ]
}

# ── 7. Notification Service (Internal, min_replicas=1) ───────────────────────
# Must always run to consume Service Bus messages

module "ca_notification_service" {
  source                       = "../modules/container-app"
  name                         = "ca-notification-service"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_apps_environment.id
  identity_id                  = module.managed_identity.id
  registry_server              = module.container_registry.login_server
  container_name               = "notification-service"
  image_name                   = "notification-service"
  target_port                  = 3005
  external_enabled             = false
  allow_insecure               = true
  min_replicas                 = 1
  max_replicas                 = 3
  tags                         = local.common_tags

  use_placeholder_image = var.use_placeholder_image

  depends_on = [
    azurerm_role_assignment.identity_kv_secrets,
    azurerm_role_assignment.identity_acr_pull,
  ]

  secrets = [
    { name = "cosmos-uri-notifications", key_vault_secret_id = azurerm_key_vault_secret.cosmos_uri_notifications.versionless_id },
    { name = "servicebus-connection-string", key_vault_secret_id = azurerm_key_vault_secret.servicebus_connection_string.versionless_id },
    { name = "acs-connection-string", key_vault_secret_id = azurerm_key_vault_secret.acs_connection_string.versionless_id },
  ]

  env_vars = [
    { name = "PORT", value = "3005" },
    { name = "MONGO_URI", secret_name = "cosmos-uri-notifications" },
    { name = "SERVICE_BUS_CONNECTION_STRING", secret_name = "servicebus-connection-string" },
    { name = "ACS_CONNECTION_STRING", secret_name = "acs-connection-string" },
    { name = "ACS_SENDER_ADDRESS", value = module.communication_services.sender_address },
  ]
}
