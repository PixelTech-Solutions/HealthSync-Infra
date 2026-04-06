locals {
  # Naming convention:  shopease-{env}-{resource}
  prefix       = "healthsync-${var.environment}"
  acr_name     = "healthsync${var.environment}acr" 
  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}