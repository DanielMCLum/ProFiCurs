# Configuración principal de WordPress en Azure (para estudiantes)
# Archivo: main.tf

# 1. Proveedor Azure
provider "azurerm" {
  features {}
}

# 2. Grupo de recursos
resource "azurerm_resource_group" "wp" {
  name     = "wordpress-student-rg"
  location = "eastus"  # Región con más beneficios gratuitos
}

# 3. App Service Plan (GRATIS con límites)
resource "azurerm_service_plan" "wp" {
  name                = "wordpress-free-plan"
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  os_type             = "Linux"
  sku_name            = "F1"  # Plan gratuito (60 mins CPU/día)
}

# 4. App Service para WordPress
resource "azurerm_linux_web_app" "wp" {
  name                = "wordpress-student-app-${random_string.suffix.result}"  # Nombre único
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  service_plan_id     = azurerm_service_plan.wp.id

  site_config {
    linux_fx_version = "PHP|8.2"  # Versión compatible con WordPress
    always_on        = false       # Requerido para plan F1 gratis
    
    application_stack {
      php_version = "8.2"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"  # Almacenamiento persistente
    
    # Configuración de WordPress
    "WORDPRESS_DB_HOST"            = azurerm_mysql_flexible_server.wp.fqdn
    "WORDPRESS_DB_USER"            = azurerm_mysql_flexible_server.wp.administrator_login
    "WORDPRESS_DB_PASSWORD"        = azurerm_mysql_flexible_server.wp.administrator_password
    "WORDPRESS_DB_NAME"            = "wordpress"
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "600"  # Tiempo extra para instalar WP
  }

  lifecycle {
    ignore_changes = [
      app_settings["WORDPRESS_DB_PASSWORD"]  # Evita sobrescribir la contraseña
    ]
  }
}

# 5. Base de datos MySQL (SKU más económica)
resource "azurerm_mysql_flexible_server" "wp" {
  name                = "wordpress-db-${random_string.suffix.result}"
  location            = azurerm_resource_group.wp.location
  resource_group_name = azurerm_resource_group.wp.name
  
  # SKU económica (≈ $15 USD/mes)
  sku_name            = "B_Standard_B1s"
  storage_mb          = 5120  # 5 GB (mínimo para WordPress)
  version             = "8.0.21"

  administrator_login          = "wpadmin"
  administrator_password       = "P@ssw0rd123!${random_string.suffix.result}"  # Contraseña segura
  backup_retention_days        = 7
  
  high_availability {
    mode = "SameZone"  # Opcional para mayor disponibilidad (aumenta costo)
  }
}

# 6. Base de datos WordPress
resource "azurerm_mysql_flexible_database" "wp" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.wp.name
  server_name         = azurerm_mysql_flexible_server.wp.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# 7. Sufijo aleatorio para nombres únicos
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 8. Reglas de firewall para MySQL (permite conexiones desde App Service)
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.wp.name
  server_name         = azurerm_mysql_flexible_server.wp.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"  # En producción, restringe esto
}