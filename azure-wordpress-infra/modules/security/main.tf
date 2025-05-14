resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "monitoring" {
  name               = "wordpress-monitoring"
  target_resource_id = var.vmss_id
  log_analytics_workspace_id = var.workspace_id
}

