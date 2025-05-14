variable "vmss_name" {
  description = "Nombre del VM Scale Set"
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

variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
}

variable "instance_count" {
  description = "Número inicial de instancias"
  type        = number
}

variable "admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegarán las VMs"
  type        = string
}

