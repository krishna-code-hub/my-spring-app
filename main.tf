terraform {
  backend "azurerm" {
    resource_group_name  = "githubwfdemo"
    storage_account_name = "strgaccttf1141"
    container_name       = "terraformgithubexample"
    key                  = "terraformgithubexample.tfstate"
  }
}
 
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}
 
data "azurerm_client_config" "current" {}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "dev-rg" {
  name     = "githubwfdemo"
  location = "South Central US"
}

# Create app service plan
resource "azurerm_app_service_plan" "service-plan" {
  name = "simple-service-plan"
  location = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "B1"
  }
  tags = {
    environment = "dev"
  }
}

# Create JAVA app service
resource "azurerm_app_service" "app-service" {
  name = "githubactiontest"
  location = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id

site_config {
    linux_fx_version = "JAVA|11-java11"
  }
tags = {
    environment = "dev"
  }
}
