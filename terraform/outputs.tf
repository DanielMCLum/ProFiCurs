# Salida del DNS del Load Balancer
output "alb_dns_name" {
  value = aws_lb.wordpress_alb.dns_name
}

# Salida del ID del sistema de archivos EFS
output "efs_id" {
  value = aws_efs_file_system.wordpress.id
}

output "rds_endpoint" {
  value = aws_db_instance.wordpress.endpoint
}



/*
output "ec2_public_ips" {
  value = [for instance in aws_instance.wordpress : instance.public_ip]
}
*/
