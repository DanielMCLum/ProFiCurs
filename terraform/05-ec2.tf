/* # Comentado la creación de instancias porque ya lo hace el ASG (AutoScalingGroup)

# Crea x instancias EC2 para alojar WordPress
resource "aws_instance" "wordpress" {
  count                       = 2                                       # Crea 2 instancias (con etiqueta: wordpress-0 y wordpress-1). Puede ser X instancias (wordpress-x)
  ami                         = var.ami_id                              # ID de la imagen (AMI) a usar (definida en variables.tf)
  instance_type               = var.instance_type                       # Tipo de instancia (ej. t2.micro)
  key_name                    = aws_key_pair.deployer.key_name          # Asocia la clave SSH generada previamente
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]    # Aplica el grupo de seguridad que permite SSH, HTTP y HTTPS
  associate_public_ip_address = true                                    # Asigna IP pública automáticamente

  tags = {
    Name = "wordpress-${count.index}"                                   # Etiqueta con nombre único por instancia
  }
}

# Comentado porque ya se usa Amazon RDS
# EC2 dedicada para MySQL 
resource "aws_instance" "mysql_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  tags = {
    Name = "mysql-server"
  }
}
*/