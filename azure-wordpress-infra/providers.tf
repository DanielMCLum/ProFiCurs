# Definición de proveedores requeridos para Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Define el origen del proveedor
      version = "~> 3.0"             # Especifica la versión compatible con Terraform
    }
  }
}

# Configuración del proveedor AzureRM para gestionar recursos en Azure
provider "azurerm" {
  features {}  # Habilita todas las características sin configuración adicional
}
