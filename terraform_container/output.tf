output "wordpress_url" {
  value       = "https://${azurerm_container_app.wp_app.ingress[0].fqdn}"
  description = "URL para acceder al sitio de WordPress"
}