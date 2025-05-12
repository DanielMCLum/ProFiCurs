# ==========================================================
# 🔧 Variables de configuración para Packer
# ==========================================================
# Este archivo define las variables necesarias para la creación
# de una imagen de máquina virtual en Azure con Packer.
# ==========================================================

# 🌍 Región de despliegue
variable "location" {
  description = "Región de Azure donde se creará la imagen"
  default     = "westeurope"
}

# 🔐 Credenciales de Azure (NO incluir valores por defecto)
variable "client_id" {
  description = "ID de la aplicación de servicio (SP) en Azure"
  type        = string
}

variable "client_secret" {
  description = "Contraseña de la aplicación de servicio (SP)"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "ID de suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

# 🏗️ Grupo de recursos para la imagen
variable "image_resource_group_name" {
  description = "Grupo de recursos donde se almacenará la imagen"
  default     = "myPackerImages2"
}

# 🛡️ Variables para la configuración de WordPress
variable "db_name" {
  description = "Nombre de la base de datos para WordPress"
  default     = "wordpress"
}

variable "db_user" {
  description = "Usuario de MySQL para WordPress"
  default     = "wordpressuser"
}

variable "db_password" {
  description = "Contraseña del usuario de MySQL para WordPress"
  type        = string
  sensitive   = true
}
