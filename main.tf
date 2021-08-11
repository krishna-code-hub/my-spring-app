terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "krishna-tfcloud"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "my-spring-app"
    }
  }
}

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
