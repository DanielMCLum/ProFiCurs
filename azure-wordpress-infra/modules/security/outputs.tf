# Output que devuelve el ID del Network Security Group (NSG) en Azure
output "nsg_id" {
  description = "ID del Network Security Group, utilizado para gestionar reglas de acceso y seguridad en la red."
  value       = azurerm_network_security_group.nsg.id
}
