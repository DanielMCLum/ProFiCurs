# ==========================================================
# 🌍 Configuración del proveedor de Azure en Terraform
# ==========================================================
# Este archivo define el proveedor de Azure y sus características.
# Se recomienda usar variables de entorno o archivos .tfvars
# para manejar credenciales de forma segura.
# ==========================================================

provider "azurerm" {
  features {}

  # ⚠️ Usa variables en lugar de credenciales expuestas
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  use_cli                     = true  # Usa autenticación con CLI de Azure
  skip_provider_registration  = true  # Evita el listado de providers
}
