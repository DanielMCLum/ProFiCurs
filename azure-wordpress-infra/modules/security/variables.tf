# Variables utilizadas para la configuración de seguridad en Azure

# Nombre del Network Security Group (NSG) utilizado para gestionar reglas de seguridad
variable "nsg_name" {
  description = "Nombre del Network Security Group"
  type        = string
}

# Ubicación donde se desplegarán los recursos de seguridad en Azure
variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

# Grupo de recursos donde se alojará el NSG y la configuración de monitoreo
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# ID del Virtual Machine Scale Set (VMSS) al que se aplicará la configuración de seguridad y monitoreo
variable "vmss_id" {
  description = "ID del VM Scale Set"
  type        = string
}

# ID del Log Analytics Workspace donde se almacenarán los registros y métricas del monitoreo
variable "workspace_id" {
  description = "ID del Log Analytics Workspace"
  type        = string
}

