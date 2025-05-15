# Creación de un Virtual Machine Scale Set (VMSS) en Azure
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name  # Nombre del VMSS
  location            = var.location  # Ubicación del despliegue
  resource_group_name = var.resource_group_name  # Grupo de recursos donde se define el VMSS
  upgrade_policy_mode = "Automatic"  # Permite actualizaciones automáticas en la VMSS

  # Configuración del tamaño y capacidad del VMSS
  sku {
    name     = var.vm_size  # Tamaño de la instancia de máquina virtual
    tier     = "Standard"  # Nivel de rendimiento
    capacity = var.instance_count  # Número de instancias a desplegar
  }

  # Definición del perfil de sistema operativo
  os_profile {
    computer_name_prefix = "wordpress"  # Prefijo del nombre de las máquinas
    admin_username       = var.admin_username  # Usuario administrador
    admin_password       = var.admin_password  # Contraseña segura para acceso remoto
  }

  # Configuración para autenticación en Linux
  os_profile_linux_config {
    disable_password_authentication = false  # Permitir autenticación por contraseña en Linux
  }

  # Perfil de red para la VMSS
  network_profile {
    name    = "wordpress-net-profile"  # Nombre del perfil de red asociado al VMSS
    primary = true  # Define la interfaz como primaria

    # Configuración de IP y asignación de subred
    ip_configuration {
      name      = "wordpress-ip-config"  # Nombre de la configuración de IP
      subnet_id = var.subnet_id  # Identificador de la subred donde se conectarán las instancias
    }
  }
}

