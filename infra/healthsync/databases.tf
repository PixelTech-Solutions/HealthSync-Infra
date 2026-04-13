# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Databases (Cosmos DB, PostgreSQL, Redis)                      ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Azure Cosmos DB (MongoDB API, Serverless) ─────────────────────────────────
# 4 databases: healthsync_auth, _patients, _prescriptions, _notifications

module "cosmos_db" {
  source              = "../modules/cosmos-db"
  name                = local.cosmos_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  databases           = local.cosmos_databases
  consistency_level   = "Session"
  tags                = local.common_tags
}

# ── Azure Database for PostgreSQL Flexible Server ─────────────────────────────
# 3 databases: healthsync_doctors, _appointments, _payments
# Deployed in northeurope (different from primary region)

module "postgresql" {
  source              = "../modules/postgresql"
  name                = local.psql_name
  resource_group_name = module.resource_group.name
  location            = var.postgresql_location
  admin_username      = var.postgresql_admin_username
  admin_password      = var.postgresql_admin_password
  sku_name            = var.postgresql_sku
  postgresql_version  = "16"
  databases           = local.postgresql_databases
  tags                = local.common_tags
}

# ── Azure Cache for Redis ─────────────────────────────────────────────────────
# Basic C0, TLS on port 6380, used by Doctor Service

module "redis" {
  source              = "../modules/redis"
  name                = local.redis_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku_name            = var.redis_sku
  capacity            = 0
  family              = "C"
  tags                = local.common_tags
}
