variable "nsg_name" {
  description = "Nombre del Network Security Group"
  type        = string
}

variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "vmss_id" {
  description = "ID del VM Scale Set"
  type        = string
}

variable "workspace_id" {
  description = "ID del Log Analytics Workspace"
  type        = string
}


