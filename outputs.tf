output "ansible_public_ip" {
  value = aws_instance.ansible_host.public_ip
}

output "wordpress_public_ip" {
  value = aws_instance.wordpress_host.public_ip
}
