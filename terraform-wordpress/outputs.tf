# ==========================================================
# 📤 Outputs de la infraestructura
# ==========================================================
# Este archivo define las salidas de Terraform, mostrando
# información útil después del despliegue.
# ==========================================================

# 🌐 IP pública de la máquina virtual
# -----------------------------------
# Devuelve la dirección IP pública asignada a la VM.
# Se puede usar para acceder a la instancia de WordPress o conectarse por SSH.
output "vm_public_ip" {
  value       = az
