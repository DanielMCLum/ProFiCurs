# Creación del servidor MySQL en Azure
resource "azurerm_mysql_server" "db" {
  name                = var.db_name  # Nombre del servidor de base de datos
  location            = var.location  # Ubicación del recurso en Azure
  resource_group_name = var.resource_group_name  # Grupo de recursos donde se crea el servidor
  sku_name            = var.db_sku  # Tipo de instancia y rendimiento
  storage_mb          = var.storage_mb  # Tamaño de almacenamiento asignado
  administrator_login = var.admin_username  # Nombre de usuario administrador
  administrator_login_password = var.admin_password  # Contraseña para el acceso
  version             = "8.0"  # Versión de MySQL utilizada
}

# Creación de la base de datos dentro del servidor MySQL
resource "azurerm_mysql_database" "wordpress_db" {
  name                = var.db_name  # Nombre de la base de datos
  resource_group_name = var.resource_group_name  # Grupo de recursos donde se crea
  server_name         = azurerm_mysql_server.db.name  # Servidor MySQL donde se aloja la BD
  charset            = "utf8"  # Codificación de caracteres utilizada
  collation          = "utf8_general_ci"  # Configuración de ordenamiento de datos
}
