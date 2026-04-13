resource "azurerm_cosmosdb_account" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "this" {
  for_each            = toset(var.databases)
  name                = each.value
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
}
