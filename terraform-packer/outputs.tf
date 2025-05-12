# ==========================================================
# 📤 Outputs de la infraestructura
# ==========================================================
# Este archivo define las salidas de Terraform, mostrando
# información útil después del despliegue.
# ==========================================================

# 🌐 URL de la aplicación WordPress
# ---------------------------------
# Devuelve la URL pública de la aplicación web desplegada.
output "wordpress_url" {
  value = "https://${azurerm_linux_web_app.wp.default_hostname}"
  description = "URL pública de la aplicación WordPress en Azure"
}
