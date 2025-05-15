# Definición de variables para la configuración del VM Scale Set en Azure

# Nombre del VM Scale Set, utilizado para gestionar múltiples instancias de máquinas virtuales
variable "vmss_name" {
  description = "Nombre del VM Scale Set"
  type        = string
}

# Ubicación donde se desplegará la infraestructura en Azure
variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

# Nombre del grupo de recursos donde se almacenarán los componentes del VMSS
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# Tamaño de las máquinas virtuales en el VM Scale Set
variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
}

# Número de instancias a desplegar dentro del VM Scale Set
variable "instance_count" {
  description = "Número inicial de instancias"
  type        = number
}

# Credenciales de acceso al sistema operativo de las máquinas virtuales
variable "admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}

# ID de la subred donde se conectarán las máquinas virtuales
variable "subnet_id" {
  description = "ID de la subred donde se desplegarán las VMs"
  type        = string
}

