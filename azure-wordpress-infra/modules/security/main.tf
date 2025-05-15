# Creación del Network Security Group (NSG) en Azure
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name  # Nombre del grupo de seguridad de red
  location            = var.location  # Ubicación del recurso en Azure
  resource_group_name = var.resource_group_name  # Grupo de recursos donde se aloja el NSG
}

# Configuración del diagnóstico y monitoreo para el VMSS en Azure
resource "azurerm_monitor_diagnostic_setting" "monitoring" {
  name                      = "wordpress-monitoring"  # Nombre de la configuración de monitoreo
  target_resource_id        = var.vmss_id  # ID del VM Scale Set a monitorear
  log_analytics_workspace_id = var.workspace_id  # ID del workspace para almacenar logs y métricas
}


