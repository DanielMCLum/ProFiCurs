variable "db_name" {
  description = "Nombre de la base de datos"
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

variable "db_sku" {
  description = "SKU de la base de datos"
  type        = string
}

variable "storage_mb" {
  description = "Tamaño de almacenamiento en MB"
  type        = number
}

variable "admin_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}

