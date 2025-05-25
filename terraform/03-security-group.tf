# ==========================================================
# Security Group para las instancias de WordPress y acceso general
# ==========================================================
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Permite SSH, HTTP, HTTPS y acceso a MySQL (3306)"
  vpc_id      = aws_vpc.main.id  # Usamos la VPC personalizada        # Para usar la default sería: vpc_id = data.aws_vpc.default.id


  # --------------------
  # Reglas de entrada
  # --------------------

  # Acceso SSH desde cualquier IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (puerto 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (puerto 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL (puerto 3306) abierto públicamente (para pruebas)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --------------------
  # Reglas de salida
  # --------------------
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"] # Hacia cualquier destino
  }

  tags = {
    Name = "wordpress-sg"
  }
}


