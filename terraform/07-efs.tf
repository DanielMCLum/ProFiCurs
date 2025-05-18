# Sistema de archivos EFS
resource "aws_efs_file_system" "wordpress" {
  creation_token = "wordpress-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "wordpress-efs"
  }
}

# Security Group para permitir NFS desde las instancias EC2
resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Permitir NFS desde instancias EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id] # Desde instancias EC2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}

# Mount targets en todas las subredes por defecto
resource "aws_efs_mount_target" "wordpress" {
  count           = length(data.aws_subnets.default.ids)
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = data.aws_subnets.default.ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

