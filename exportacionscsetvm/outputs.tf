output "load_balancer_ip" {
  value = azapi_resource.public_ip.body.properties.ipAddress
}

output "resource_group_name" {
  value = var.resource_group_name
}