/*
# Crea x instancias EC2 para alojar WordPress
resource "aws_instance" "wordpress" {
  count                       = 2                                       # Crea 2 instancias (wordpress-0 y wordpress-1)
  ami                         = var.ami_id                              # ID de la imagen (AMI) a usar (definida en variables.tf)
  instance_type               = var.instance_type                       # Tipo de instancia (ej. t2.micro)
  key_name                    = aws_key_pair.deployer.key_name          # Asocia la clave SSH generada previamente
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]    # Aplica el grupo de seguridad que permite SSH, HTTP y HTTPS
  associate_public_ip_address = true                                    # Asigna IP pública automáticamente

  tags = {
    Name = "wordpress-${count.index}"                                   # Etiqueta con nombre único por instancia
  }
}

*/
