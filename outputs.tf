output "instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.wordpress_instance.public_ip
}

output "instance_private_key" {
  description = "Nombre del par de claves SSH asociado a la instancia"
  value       = var.key_pair_name
}