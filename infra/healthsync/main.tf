# module "resource_group" {
#   source   = "../modules/resource-group"
#   name     = "${local.prefix}-rg"
#   location =  var.location
#   tags     =  local.common_tags
# }

module "container_registry" {
  source   = "../modules/acr"
  name     = local.acr_name
  location =  var.location
  resource_group_name = var.resource_group_name
  sku = var.acr_sku
  admin_enabled = true
  tags     =  local.common_tags
}