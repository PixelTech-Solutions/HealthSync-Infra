# ── Front Door Profile ────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

# ── Endpoint ──────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = var.endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  tags                     = var.tags
}

# ── Origin Groups ─────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each                 = var.origin_groups
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  load_balancing {
    sample_size                 = each.value.sample_size
    successful_samples_required = each.value.successful_samples_required
  }

  dynamic "health_probe" {
    for_each = each.value.health_probe_path != null ? [1] : []
    content {
      interval_in_seconds = each.value.health_probe_interval
      path                = each.value.health_probe_path
      protocol            = "Https"
      request_type        = "HEAD"
    }
  }
}

# ── Origins ───────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each                       = var.origins
  name                           = each.key
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_key].id
  host_name                      = each.value.host_name
  origin_host_header             = coalesce(each.value.origin_host_header, each.value.host_name)
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  enabled                        = each.value.enabled
}

# ── SPA Rewrite Rule Set ──────────────────────────────────────────────────────
# Rewrites non-file paths to /index.html for SPA client-side routing

resource "azurerm_cdn_frontdoor_rule_set" "spa_rewrite" {
  count                    = var.enable_spa_rewrite ? 1 : 0
  name                     = "SpaRewrite"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_rule" "spa_rewrite" {
  count                     = var.enable_spa_rewrite ? 1 : 0
  name                      = "SpaRewriteRule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.spa_rewrite[0].id
  order                     = 1

  conditions {
    url_filename_condition {
      operator     = "Equal"
      match_values = [""]
    }
  }

  actions {
    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/index.html"
      preserve_unmatched_path = false
    }
  }
}

# ── Routes ────────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_route" "this" {
  for_each                      = var.routes
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_key].id
  cdn_frontdoor_origin_ids      = [for k in each.value.origin_keys : azurerm_cdn_frontdoor_origin.this[k].id]

  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
  https_redirect_enabled = each.value.https_redirect_enabled
  forwarding_protocol    = each.value.forwarding_protocol
  link_to_default_domain = true

  cdn_frontdoor_rule_set_ids = each.value.rule_set_key != null && var.enable_spa_rewrite ? [azurerm_cdn_frontdoor_rule_set.spa_rewrite[0].id] : []
}
