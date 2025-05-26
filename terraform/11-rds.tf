# ========================================================
# Subnet Group para Amazon RDS (define en qué subredes puede estar la base de datos)
# ========================================================
resource "aws_db_subnet_group" "wordpress" {
  name = "wordpress-subnet-group"

  # Usamos nuestras subredes personalizadas de la VPC privada
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "WordPress DB Subnet Group"
  }
}

# ========================================================
# Instancia RDS (MySQL) para WordPress
# ========================================================
resource "aws_db_instance" "wordpress" {
  identifier        = "wordpress-db"        # Nombre único
  engine            = "mysql"               # Tipo de motor de base de datos
  engine_version    = "8.0"                 # Versión del motor
  instance_class    = "db.t3.micro"         # Tipo de instancia (gratis con Free Tier)
  allocated_storage = 20                    # Almacenamiento inicial en GB
  storage_type      = "gp2"                 # Tipo de almacenamiento (general purpose SSD)

  # Política de backup (Habilitar en producción)
  # backup_retention_period = 7               # Guarda los backups de los últimos 7 días
  # preferred_backup_window = "03:00-06:00"   # Horario de baja actividad

  # Datos de acceso y nombre de la BBDD
  db_name           = var.wp_db_name
  username          = var.wp_db_user
  password          = var.wp_db_password
  port              = 3306                  # Puerto estándar MySQL

  # Seguridad y red
  publicly_accessible     = false           # No accesible desde internet
  multi_az                = false           # No usamos alta disponibilidad Multi-AZ
  vpc_security_group_ids  = [aws_security_group.wordpress_sg.id]  # Acceso solo desde WordPress
  db_subnet_group_name    = aws_db_subnet_group.wordpress.name     # Subredes válidas
  skip_final_snapshot     = true            # Evita snapshot al destruir (útil en pruebas)

  tags = {
    Name = "WordPress-RDS"
  }
}
