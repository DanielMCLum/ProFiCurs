provider "azurerm" {
  features {}
  subscription_id = "9c83b4e6-cccc-4027-b0b1-3c6ff5807320"  # Obligatorio
  client_id       = "tu-client-id"          # Opcional si usas az login
  client_secret   = "tu-client-secret"      # Opcional si usas az login
  tenant_id       = "836f1d43-90b9-41eb-815f-6e37bd65ff30"  # Opcional si usas az login
}