output "wordpress_url" {
  value = "https://${azurerm_linux_web_app.wp.default_hostname}"
}