resource "azurerm_mysql_server" "db" {
  name                = var.db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.db_sku
  storage_mb          = var.storage_mb
  administrator_login = var.admin_username
  administrator_login_password = var.admin_password
  version             = "8.0"
}

resource "azurerm_mysql_database" "wordpress_db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.db.name
  charset            = "utf8"
  collation          = "utf8_general_ci"
}

