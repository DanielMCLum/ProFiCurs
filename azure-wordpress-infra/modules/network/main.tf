# Creación de la Red Virtual (VNet) en Azure
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name  # Nombre de la VNet
  location            = var.location  # Ubicación del recurso en Azure
  resource_group_name = var.resource_group_name  # Grupo de recursos donde se aloja la red
  address_space       = var.address_space  # Espacio de direcciones IP asignado
}

# Creación de la subred pública dentro de la VNet
resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name  # Nombre de la subred pública
  resource_group_name  = var.resource_group_name  # Grupo de recursos donde se aloja
  virtual_network_name = azurerm_virtual_network.vnet.name  # Asociación con la VNet creada
  address_prefixes     = var.public_subnet_prefix  # Prefijo de direcciones IP asignadas a la subred pública
}

# Creación de la subred privada dentro de la VNet
resource "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name  # Nombre de la subred privada
  resource_group_name  = var.resource_group_name  # Grupo de recursos donde se aloja
  virtual_network_name = azurerm_virtual_network.vnet.name  # Asociación con la VNet creada
  address_prefixes     = var.private_subnet_prefix  # Prefijo de direcciones IP asignadas a la subred privada
}
