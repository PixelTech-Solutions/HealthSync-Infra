locals {
  # ── Naming ──────────────────────────────────────────────────────────────────
  # Matches actual deployed resource names: {type}-{project}-{env}
  env      = var.environment
  rg_name  = "rg-${var.project_name}-${local.env}"
  acr_name = "cr${var.project_name}"
  kv_name  = "kv-${var.project_name}-${local.env}"
  cae_name = "cae-${var.project_name}-${local.env}"
  id_name  = "id-${var.project_name}-${local.env}"
  fd_name  = "fd-${var.project_name}"
  sb_name  = "sb-${var.project_name}-${local.env}"
  st_name  = "st${var.project_name}web"
  acs_name = "acs-${var.project_name}-${local.env}"
  ecs_name = "ecs-${var.project_name}-${local.env}"

  # Database resource names
  cosmos_name = "cosmos-${var.project_name}-${local.env}"
  psql_name   = "psql-${var.project_name}-${local.env}"
  redis_name  = "redis-${var.project_name}-${local.env}"

  # Log Analytics (auto-generated style to match existing)
  law_name = "law-${var.project_name}-${local.env}"

  # ── Database lists ──────────────────────────────────────────────────────────
  cosmos_databases = [
    "healthsync_auth",
    "healthsync_patients",
    "healthsync_prescriptions",
    "healthsync_notifications",
  ]

  postgresql_databases = [
    "healthsync_doctors",
    "healthsync_appointments",
    "healthsync_payments",
  ]

  # ── Service Bus queues ──────────────────────────────────────────────────────
  servicebus_queues = [
    "appointment-events",
    "prescription-events",
    "doctor-events",
  ]

  # ── Tags ────────────────────────────────────────────────────────────────────
  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  # ── Constructed values (available after module apply) ───────────────────────
  # Cosmos DB per-database connection strings
  cosmos_db_uris = {
    for db in local.cosmos_databases : db => replace(
      module.cosmos_db.primary_mongodb_connection_string,
      "10255/?",
      "10255/${db}?"
    )
  }

  # Internal Container Apps base URL
  cae_internal_base = "https://{app}.internal.${module.container_apps_environment.default_domain}"

  # Service internal URLs (used by API Gateway)
  service_urls = {
    patient      = replace(local.cae_internal_base, "{app}", "ca-patient-service")
    doctor       = replace(local.cae_internal_base, "{app}", "ca-doctor-service")
    appointment  = replace(local.cae_internal_base, "{app}", "ca-appointment-service")
    prescription = replace(local.cae_internal_base, "{app}", "ca-prescription-service")
    notification = replace(local.cae_internal_base, "{app}", "ca-notification-service")
    payment      = replace(local.cae_internal_base, "{app}", "ca-payment-service")
  }
}
