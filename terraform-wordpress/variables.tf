# ==========================================================
# 🔧 Variables de configuración
# ==========================================================
# Este archivo define las variables necesarias para la infraestructura
# en Azure. Se recomienda usar un archivo terraform.tfvars para valores sensibles.
# ==========================================================

# 🌍 Región de despliegue
# -----------------------
# Define la ubicación donde se crearán los recursos en Azure.
variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  default     = "westeurope"  # Región recomendada por estabilidad
}

# 🔐 Contraseña del administrador
# --------------------------------
# Define la contraseña del usuario administrador de la máquina virtual.
# ⚠️ Se recomienda NO incluir valores por defecto en el código y usar terraform.tfvars.
variable "admin_password" {
  description = "Contraseña para el usuario administrador de la VM"
  default     = "P@ssw0rd123!"  # ⚠️ ¡No expongas credenciales en el código!
}

# 🏗️ Nombre del grupo de recursos
# --------------------------------
# Define el nombre del grupo de recursos donde se alojarán los servicios.
variable "resource_group_name" {
  description = "Nombre del grupo de recursos en Azure"
  default     = "wordpressResourceGroup"
}

