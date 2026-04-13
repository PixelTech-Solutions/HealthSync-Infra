# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Networking (Storage Account, Front Door CDN)                  ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

# ── Storage Account (Static Website + Avatars) ────────────────────────────────

module "storage_account" {
  source                   = "../modules/storage-account"
  name                     = local.st_name
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_static_website    = true
  index_document           = "index.html"
  error_404_document       = "index.html"
  tags                     = local.common_tags

  containers = [
    { name = "avatars", access_type = "blob" },
  ]
}

# ── Azure Front Door (CDN + API routing) ──────────────────────────────────────

module "front_door" {
  source              = "../modules/front-door"
  name                = local.fd_name
  resource_group_name = module.resource_group.name
  endpoint_name       = "healthsync-${var.environment}"
  sku_name            = "Standard_AzureFrontDoor"
  tags                = local.common_tags

  origin_groups = {
    frontend = {
      health_probe_path = "/"
    }
    api = {
      health_probe_path = "/health"
    }
  }

  origins = {
    frontend-origin = {
      origin_group_key = "frontend"
      host_name        = module.storage_account.primary_web_host
    }
    api-origin = {
      origin_group_key = "api"
      host_name        = module.ca_api_gateway.ingress_fqdn
    }
  }

  enable_spa_rewrite = true

  routes = {
    api-route = {
      origin_group_key    = "api"
      origin_keys         = ["api-origin"]
      patterns_to_match   = ["/api/*"]
      forwarding_protocol = "HttpsOnly"
    }
    frontend-route = {
      origin_group_key    = "frontend"
      origin_keys         = ["frontend-origin"]
      patterns_to_match   = ["/*"]
      forwarding_protocol = "HttpsOnly"
      rule_set_key        = "spa_rewrite"
    }
  }
}
