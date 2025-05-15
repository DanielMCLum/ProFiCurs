# Output que devuelve el ID del servidor de base de datos en Azure
output "db_id" {
  description = "ID del servidor de base de datos, utilizado para la gestión y conexión con la aplicación."
  value       = azurerm_mysql_server.db.id
}
