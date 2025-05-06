provider "azurerm" {
  features {}
  subscription_id = "9c83b4e6-cccc-4027-b0b1-3c6ff5807320"  # Reemplaza con tu ID
  client_id       = "bf55d652-be5e-4cbd-94f6-05faecbbb6a7"    # appId del SP
  client_secret   = "WDa8Q~0MTuNX0zfasaDqR5hPYE68PwLUu3dCzbbl" # password del SP
  tenant_id       = "836f1d43-90b9-41eb-815f-6e37bd65ff30" # tenant del SP
}