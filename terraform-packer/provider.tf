provider "azurerm" {
  features {}
  subscription_id = "tu-id-de-suscripcion"  # Obligatorio
  client_id       = "tu-client-id"          # Opcional si usas az login
  client_secret   = "tu-client-secret"      # Opcional si usas az login
  tenant_id       = "tu-tenant-id"          # Opcional si usas az login
}