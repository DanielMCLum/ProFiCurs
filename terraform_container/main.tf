# === SUFIJO ALEATORIO PARA MYSQL ===
resource "random_string" "mysql_suffix" {
  length  = 6
  special = false
  upper   = false
}

# === GRUPO DE RECURSOS ===
resource "azurerm_resource_group" "wp_rg" {
  name     = var.resource_group_name
  location = var.location
}

# === VNET Y SUBREDES ===
resource "azurerm_virtual_network" "wp_vnet" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.wp_rg.name
  address_space       = ["10.0.0.0/21"]
}

resource "azurerm_subnet" "mysql_subnet" {
  name                 = "mysql-subnet"
  resource_group_name  = azurerm_resource_group.wp_rg.name
  virtual_network_name = azurerm_virtual_network.wp_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "apps_subnet" {
  name                 = "apps-subnet"
  resource_group_name  = azurerm_resource_group.wp_rg.name
  virtual_network_name = azurerm_virtual_network.wp_vnet.name
  address_prefixes     = ["10.0.2.0/23"]
}

# === DNS PRIVADO ===
resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.wp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_link" {
  name                  = "mysql-dns-link"
  resource_group_name   = azurerm_resource_group.wp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.wp_vnet.id
  registration_enabled  = false
}

# === LOG ANALYTICS PARA CONTAINER APPS ===
resource "azurerm_log_analytics_workspace" "wp_log" {
  name                = "${var.prefix}-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.wp_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# === ENTORNO CON VNET INTEGRADA PARA CONTAINER APPS ===
resource "azurerm_container_app_environment" "wp_env" {
  name                        = "${var.prefix}-env"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.wp_rg.name
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.wp_log.id
  infrastructure_subnet_id    = azurerm_subnet.apps_subnet.id
  internal_load_balancer_enabled = false
}

# === MYSQL FLEXIBLE SERVER ===
resource "azurerm_mysql_flexible_server" "wp_mysql" {
  name                   = "${var.prefix}-mysql-${random_string.mysql_suffix.result}"
  resource_group_name    = azurerm_resource_group.wp_rg.name
  location               = var.location
  administrator_login    = "mysqladmin"
  administrator_password = "SecurePassword123!" # Usa secreto real
  sku_name               = "B_Standard_B1ms"
  version                = "5.7"
  delegated_subnet_id    = azurerm_subnet.mysql_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id

  storage {
    size_gb = 32
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql_link
  ]
}

# Ajuste temporal para deshabilitar obligatoriedad de conexiones con certificado
# No es lo mejor, pero como está en una subred privada, tampoco es accesible desde fuera
resource "azurerm_mysql_flexible_server_configuration" "disable_ssl" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.wp_rg.name
  server_name         = azurerm_mysql_flexible_server.wp_mysql.name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_database" "wp_database" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.wp_rg.name
  server_name         = azurerm_mysql_flexible_server.wp_mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# === CONTAINER APP: WORDPRESS ===
resource "azurerm_container_app" "wp_app" {
  name                          = "${var.prefix}-wp"
  container_app_environment_id = azurerm_container_app_environment.wp_env.id
  resource_group_name           = azurerm_resource_group.wp_rg.name
  revision_mode                 = "Single"

  template {
    container {
      name   = "wordpress"
      image  = "wordpress:latest"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "WORDPRESS_DB_HOST"
        value = "${azurerm_mysql_flexible_server.wp_mysql.name}.privatelink.mysql.database.azure.com:3306"
      }
      env {
        name  = "WORDPRESS_DB_NAME"
        value = azurerm_mysql_flexible_database.wp_database.name
      }
      env {
        name  = "WORDPRESS_DB_USER"
        value = "mysqladmin"
      }
      env {
        name  = "WORDPRESS_DB_PASSWORD"
        value = "SecurePassword123!" # Usa secreto real
      }
    }

    min_replicas = 1
    max_replicas = 3

    custom_scale_rule {
      name             = "cpu-scaling"
      custom_rule_type = "cpu"
      metadata = {
        type     = "Utilization"
        value    = "60"
        cooldown = "30"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_mysql_flexible_server.wp_mysql
  ]
}