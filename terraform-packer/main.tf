# Configuración principal de WordPress en Azure (para estudiantes)
# Archivo: main.tf


# 1. Grupo de recursos
resource "azurerm_resource_group" "wp" {
  name     = "wordpress-student-rg"
  location = "eastus"  # Región con más beneficios gratuitos
}

# 2. App Service Plan (GRATIS con límites)
resource "azurerm_service_plan" "wp" {
  name                = "wordpress-free-plan"
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  os_type             = "Linux"
  sku_name            = "F1"  # Plan gratuito (60 mins CPU/día)
}

# 3. App Service para WordPress
resource "azurerm_linux_web_app" "wp" {
  name                = "wordpress-app-${random_string.suffix.result}"
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  service_plan_id     = azurerm_service_plan.wp.id

  site_config {
    application_stack {
      php_version = "8.2"  # Versión PHP para WordPress
    }
    always_on = false  # Necesario para plan F1 gratis
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "WORDPRESS_DB_HOST"                   = azurerm_mysql_flexible_server.wp.fqdn
    "WORDPRESS_DB_USER"                   = azurerm_mysql_flexible_server.wp.administrator_login
    "WORDPRESS_DB_PASSWORD"               = var.mysql_admin_password
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "600"  # Tiempo extra para instalar WP
  }

  lifecycle {
    ignore_changes = [
      app_settings["WORDPRESS_DB_PASSWORD"]  # Evita sobrescribir la contraseña
    ]
  }
}

# 4. Base de datos MySQL (SKU más económica)
resource "azurerm_mysql_flexible_server" "wp" {
  name                = "wordpress-db-${random_string.suffix.result}" # Nombre único
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  
  # SKU económica verificada para estudiantes
  sku_name   = "B_Standard_B1ms"  # Burstable con 1 vCore y 2GB RAM
  version    = "8.0.21"
  
  storage {
    size_gb           = 20  # Mínimo requerido ahora
    auto_grow_enabled = false # Para controlar costos
    iops              = 360 # Mínimo para 20GB
  }

  administrator_login          = "wpadmin"
  administrator_password       = var.mysql_admin_password
  
  backup_retention_days        = 1  # Mínimo permitido para ahorrar
  geo_redundant_backup_enabled = false
}
  
# 5. Base de datos WordPress
resource "azurerm_mysql_flexible_database" "wp" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.wp.name
  server_name         = azurerm_mysql_flexible_server.wp.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# 6. Sufijo aleatorio para nombres únicos
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 7. Reglas de firewall para MySQL (permite conexiones desde App Service)
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.wp.name
  server_name         = azurerm_mysql_flexible_server.wp.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"  # En producción, restringe esto
}