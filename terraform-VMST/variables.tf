# --Variables para Azure--

variable "database_name" {} // Nombre de la base de datos
variable "database_password" {} // Contraseña de la base de datos
variable "database_user" {} // Usuario de la base de datos
variable "region" { // Región en Azure
  default = "East US"
}
variable "resource_group_name" {} // Nombre del grupo de recursos
variable "IsUbuntu" { // Indicamos que la instancia es Ubuntu
  type    = bool
  default = true
}
variable "subnet_ids" { // Lista de subredes en Azure
  type = list(string)
}
variable "PUBLIC_KEY_PATH" {} // Ruta de la clave pública
variable "PRIV_KEY_PATH" {} // Ruta de la clave privada
variable "KEY_PUTTY" {} // Ruta de la clave para Putty
variable "vm_size" {} // Tamaño de la VM en Azure
variable "database_sku" {} // SKU para la base de datos
variable "database_engine" {} // Motor de la base de datos (MySQL/PostgreSQL)
variable "engine_version" {} // Versión del motor de la base de datos
variable "backup_retention_period" {} // Período de retención de copias de seguridad
variable "preferred_backup_window" {} // Ventana de tiempo para backups
variable "preferred_maintenance_window" {} // Ventana de mantenimiento
variable "key_name" {} // Nombre de la clave SSH
variable "root_volume_size" {} // Tamaño de almacenamiento
