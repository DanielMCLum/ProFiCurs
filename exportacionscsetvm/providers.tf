terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.28.0"  # o la versión adecuada disponible
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"  # confirma en https://registry.terraform.io/providers/azure/azapi/latest
    }
  }
}

provider "azapi" {}

provider "azurerm" {
  features {}
}