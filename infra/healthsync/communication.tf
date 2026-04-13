# ╔═══════════════════════════════════════════════════════════════════════════════╗
# ║  HealthSync — Communication Services (ACS Email)                            ║
# ╚═══════════════════════════════════════════════════════════════════════════════╝

module "communication_services" {
  source              = "../modules/communication-services"
  name                = local.acs_name
  email_service_name  = local.ecs_name
  resource_group_name = module.resource_group.name
  data_location       = var.acs_data_location
  tags                = local.common_tags
}
