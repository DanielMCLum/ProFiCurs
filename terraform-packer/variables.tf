# ==========================================================
# 🔧 Variables de configuración
# ==========================================================
# Este archivo define las variables necesarias para la infraestructura
# en Azure. Se recomienda usar un archivo terraform.tfvars para valores sensibles.
# ==========================================================

# 🌍 Región de despliegue
variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  default     = "eastus"  # Región con más beneficios gratuitos
}

# 🔐 Credenciales de Azure (NO incluir valores por defecto)
variable "subscription_id" {
  description = "ID de suscripción de Azure"
  type        = string
}

variable "client_id" {
  description = "ID de la aplicación de servicio (SP)"
  type        = string
}

variable "client_secret" {
  description = "Contraseña de la aplicación de servicio (SP)"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

# 🛡️ Contraseña de MySQL (NO incluir valores por defecto)
variable "mysql_admin_password" {
  description = "Contraseña para el administrador de MySQL"
  type        = string
  sensitive   = true
}
