# Crear sistema de archivos EFS
resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name = "wordpress-efs"
  }
}

# Crear punto de montaje en cada subred (uno por AZ)
resource "aws_efs_mount_target" "efs_mount" {
  count          = length(data.aws_subnets.default.ids)
  file_system_id = aws_efs_file_system.wordpress_efs.id
  subnet_id      = data.aws_subnets.default.ids[count.index]
  security_groups = [aws_security_group.wordpress_sg.id]
}

# Exportar ID del EFS para Ansible
output "efs_id" {
  value = aws_efs_file_system.wordpress_efs.id
}
