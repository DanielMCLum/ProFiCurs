# Crea un grupo de seguridad que permitirá el tráfico necesario para WordPress
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"                            # Nombre del Security Group
  description = "Allow SSH, HTTP, and HTTPS"              # Descripción para identificar su propósito
  vpc_id      = data.aws_vpc.default.id                   # Asocia el SG a la VPC por defecto de AWS

  # Reglas de entrada (ingress)

  ingress {
    from_port   = 22                                      # Puerto SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                           # Permite conexión SSH desde cualquier IP
  }

  ingress {
    from_port   = 80                                      # Puerto HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                           # Permite navegación web (HTTP) desde cualquier IP
  }

  ingress {
    from_port   = 443                                     # Puerto HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                           # Permite navegación segura (HTTPS)
  }

  # Regla de salida (egress): permite cualquier tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                                    # -1 significa "todos los protocolos"
    cidr_blocks = ["0.0.0.0/0"]                           # Permite salida hacia cualquier IP
  }
}

