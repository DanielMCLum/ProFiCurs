# Outputs del módulo de red
output "vnet_id" {
  description = "ID de la VNet creada, utilizada para gestionar la red virtual."
  value       = module.network.vnet_id
}

# Outputs del módulo de cómputo
output "vmss_id" {
  description = "ID del VM Scale Set, utilizado para gestionar múltiples instancias de VM."
  value       = module.compute.vmss_id
}

# Outputs del módulo de base de datos
output "db_id" {
  description = "ID del servidor de base de datos, esencial para la conectividad de la aplicación."
  value       = module.database.db_id
}

# Outputs del módulo de seguridad
output "nsg_id" {
  description = "ID del Network Security Group, encargado de definir reglas de acceso y protección."
  value       = module.security.nsg_id
}
