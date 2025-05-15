# Variables utilizadas en Terraform para definir la infraestructura
# Ubicación donde se desplegarán los recursos en Azure
variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

# Nombre del grupo de recursos donde se gestionará la infraestructura
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# Credenciales del usuario administrador para gestionar las instancias de VM
variable "admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}

# Tamaño de las máquinas virtuales a desplegar
variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
}

# Cantidad de instancias de máquina virtual a aprovisionar
variable "instance_count" {
  description = "Número inicial de instancias"
  type        = number
}

