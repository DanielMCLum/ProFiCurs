# Crear un sistema de archivos EFS (almacenamiento compartido entre instancias EC2)
resource "aws_efs_file_system" "wordpress" {
  creation_token = "wordpress-efs"  # Identificador único para evitar duplicados en caso de errores de red

  # Política de ciclo de vida: archivos sin acceso en 30 días se mueven a almacenamiento "infrecuente"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "wordpress-efs"
  }
}

# Crear un grupo de seguridad que permite conexiones NFS solo desde nuestras instancias WordPress
resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Permitir NFS desde instancias EC2"
  vpc_id      = data.aws_vpc.default.id  # Asocia el SG a la VPC por defecto

  # Permitir tráfico TCP al puerto 2049 (protocolo NFS), solo desde el SG de las instancias WordPress
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  # Permitir cualquier salida
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

# Crear un punto de montaje (Mount Target) en cada subred para que las instancias puedan acceder al EFS
resource "aws_efs_mount_target" "wordpress" {
  count           = length(data.aws_subnets.default.ids)  # Un mount target por subred
  file_system_id  = aws_efs_file_system.wordpress.id      # ID del sistema de archivos EFS
  subnet_id       = data.aws_subnets.default.ids[count.index]  # Subred donde se creará
  security_groups = [aws_security_group.efs_sg.id]        # Grupo de seguridad para controlar el acceso
}

