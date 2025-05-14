resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  upgrade_policy_mode = "Automatic"

  sku {
    name     = var.vm_size
    tier     = "Standard"
    capacity = var.instance_count
  }

  os_profile {
    computer_name_prefix = "wordpress"
    admin_username       = var.admin_username
    admin_password       = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "wordpress-net-profile"
    primary = true

    ip_configuration {
      name      = "wordpress-ip-config"
      subnet_id = var.subnet_id
    }
  }
}

