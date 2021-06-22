# Configure the Microsoft Azure Provider.
terraform {
    backend "azurerm" {
        resource_group_name   = "tfstate"
        storage_account_name  = "tfstate26116"
        container_name        = "tfstate"
        key                   = "terraform.tfstate"
        access_key            = "xxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 2.46"
        }
    }
}

provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxxxxxxxxx"
  client_id       = "xxxxxxxxxxxxxx"
  client_secret   = var.client_secret
  tenant_id       = "xxxxxxxxxxxxxxxxxx"

}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}TF"
  location = var.location
  tags     = var.tags
}
