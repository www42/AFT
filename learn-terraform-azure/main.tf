terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.9"
    }
  }
  required_version = ">=1.0"
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = "Terra-RG"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["172.16.0.0/24", "11.8.15.0/24"]

  subnet {
    address_prefix = "172.16.0.0/26"
    name           = "subnet-server"
  }

  subnet {
    address_prefix = "11.8.15.128/25"
    name           = "subnet-db"
  }
}