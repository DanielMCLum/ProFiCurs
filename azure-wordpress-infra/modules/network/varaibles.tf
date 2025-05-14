variable "vnet_name" {
  description = "Nombre de la VNet"
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

variable "address_space" {
  description = "Espacio de direcciones IP para la VNet"
  type        = list(string)
}

variable "public_subnet_name" {
  description = "Nombre de la subred pública"
  type        = string
}

variable "public_subnet_prefix" {
  description = "Prefijo de la subred pública"
  type        = list(string)
}

variable "private_subnet_name" {
  description = "Nombre de la subred privada"
  type        = string
}

variable "private_subnet_prefix" {
  description = "Prefijo de la subred privada"
  type        = list(string)
}

