# Configure the Microsoft Azure Provider.
terraform {
    backend "azurerm" {
        resource_group_name   = "tfstate"
        storage_account_name  = "tfstate26116"
        container_name        = "tfstate"
        key                   = "terraform.tfstate"
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
  subscription_id = "0a52391c-0d81-434e-90b4-d04f5c670e8a"
  client_id       = "709dd768-92b4-43d6-b6e9-fe0578960fc8"
  client_secret   = var.client_secret
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"

}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}TF"
  location = var.location
  tags     = var.tags
}
