output "vnet_id" {
  description = "ID de la VNet creada"
  value       = azurerm_virtual_network.vnet.id
}

output "public_subnet_id" {
  description = "ID de la subred pública"
  value       = azurerm_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID de la subred privada"
  value       = azurerm_subnet.private_subnet.id
}

