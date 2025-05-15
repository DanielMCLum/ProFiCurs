# Output que devuelve el ID del VM Scale Set creado en Azure
output "vmss_id" {
  description = "ID del VM Scale Set, utilizado para gestionar múltiples instancias de máquinas virtuales."
  value       = azurerm_virtual_machine_scale_set.vmss.id
}
