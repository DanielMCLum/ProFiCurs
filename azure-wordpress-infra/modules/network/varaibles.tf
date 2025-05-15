# Variables utilizadas para la configuración de la Virtual Network en Azure

# Nombre asignado a la Virtual Network (VNet)
variable "vnet_name" {
  description = "Nombre de la VNet"
  type        = string
}

# Ubicación donde se desplegará la VNet en Azure
variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

# Grupo de recursos en Azure donde se creará la VNet
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# Espacio de direcciones IP asignado a la VNet
variable "address_space" {
  description = "Espacio de direcciones IP para la VNet"
  type        = list(string)
}

# Configuración de la subred pública dentro de la VNet
variable "public_subnet_name" {
  description = "Nombre de la subred pública"
  type        = string
}

variable "public_subnet_prefix" {
  description = "Prefijo de la subred pública"
  type        = list(string)
}

# Configuración de la subred privada dentro de la VNet
variable "private_subnet_name" {
  description = "Nombre de la subred privada"
  type        = string
}

variable "private_subnet_prefix" {
  description = "Prefijo de la subred privada"
  type        = list(string)
}
