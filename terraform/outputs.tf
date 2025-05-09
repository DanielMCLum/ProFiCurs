output "alb_dns_name" {
  value = aws_lb.wordpress_alb.dns_name
}

output "ec2_public_ips" {
  value = [for instance in aws_instance.wordpress : instance.public_ip]
}

