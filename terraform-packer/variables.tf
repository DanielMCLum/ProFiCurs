variable "location" {
  description = "Región de Azure"
  default     = "eastus"  # Región con más beneficios gratuitos
}

variable "mysql_admin_password" {
  description = "Contraseña para MySQL"
  type        = string
  sensitive   = true
  default     = "Aneto_3404" 
}