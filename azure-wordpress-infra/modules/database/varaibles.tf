# Variables utilizadas para la configuración de la base de datos en Azure

# Nombre de la base de datos creada en MySQL
variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

# Ubicación donde se desplegará la base de datos en Azure
variable "location" {
  description = "Ubicación de la infraestructura"
  type        = string
}

# Nombre del grupo de recursos donde se alojará la base de datos
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# SKU de la base de datos que define su rendimiento y capacidad
variable "db_sku" {
  description = "SKU de la base de datos"
  type        = string
}

# Tamaño de almacenamiento en MB para la base de datos
variable "storage_mb" {
  description = "Tamaño de almacenamiento en MB"
  type        = number
}

# Usuario administrador que tendrá acceso y privilegios sobre la base de datos
variable "admin_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
}

# Contraseña segura para el usuario administrador
variable "admin_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}


