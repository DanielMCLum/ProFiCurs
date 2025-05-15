# Output que devuelve el ID de la VNet creada en Azure
output "vnet_id" {
  description = "ID de la VNet creada, utilizada para gestionar la infraestructura de red virtual."
  value       = azurerm_virtual_network.vnet.id
}

# Output que devuelve el ID de la subred pública dentro de la VNet
output "public_subnet_id" {
  description = "ID de la subred pública, utilizada para el tráfico de red accesible externamente."
  value       = azurerm_subnet.public_subnet.id
}

# Output que devuelve el ID de la subred privada dentro de la VNet
output "private_subnet_id" {
  description = "ID de la subred privada, utilizada para recursos internos con restricciones de acceso."
  value       = azurerm_subnet.private_subnet.id
}


