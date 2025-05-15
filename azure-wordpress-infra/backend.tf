# Configuración del backend de Terraform en Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"  # Grupo de recursos donde se almacena el estado
    storage_account_name = "terraformstate"      # Cuenta de almacenamiento de Terraform
    container_name       = "tfstate"             # Contenedor donde se guarda el archivo de estado
    key                  = "azure-wordpress-infra.tfstate"  # Archivo que almacena el estado de la infraestructura
  }
}

