terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.68"
    }
  }
  required_version = ">=1.0"
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = "myTF-RG"
  location = "westeurope"
}