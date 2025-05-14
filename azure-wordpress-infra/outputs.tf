output "vnet_id" {
  description = "ID de la VNet creada"
  value       = module.network.vnet_id
}

output "vmss_id" {
  description = "ID del VM Scale Set"
  value       = module.compute.vmss_id
}

output "db_id" {
  description = "ID del servidor de base de datos"
  value       = module.database.db_id
}

output "nsg_id" {
  description = "ID del Network Security Group"
  value       = module.security.nsg_id
}

