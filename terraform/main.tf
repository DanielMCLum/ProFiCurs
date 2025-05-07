# Genera claves SSH y las guarda localmente
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/devops.pem"
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "0600"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Security Group
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Obtener VPC default (para no tener que crear una nueva)
data "aws_vpc" "default" {
  default = true
}

# Crear instancia EC2
resource "aws_instance" "wordpress" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Wordpress-Server"
  }
}

# Elastic IP
resource "aws_eip" "wp_eip" {
  domain = "vpc"
}


# Asociación de EIP con la instancia (por separado)
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.wp_eip.id
}


