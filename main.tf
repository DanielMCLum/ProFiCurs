Este código de Terraform despliega una infraestructura básica en AWS para gestionar un entorno de WordPress con Ansible. La configuración hace lo siguiente:

1. **Configura el proveedor AWS** en la región us-east-1 (Norte de Virginia).

2. **Crea un Security Group** llamado "wordpress_sg" que:
   - Permite conexiones SSH (puerto 22) desde cualquier dirección IP (0.0.0.0/0)
   - Permite tráfico HTTP (puerto 80) para acceder a WordPress
   - Autoriza todo el tráfico saliente (egress)

3. **Despliega dos instancias EC2**:
   - **ansible_host**: Una instancia t2.micro con Amazon Linux 2 que:
     * Tiene asociada la clave SSH "AWS-Samuel"
     * Usa el security group creado anteriormente
     * Instala automáticamente Ansible mediante user_data al iniciarse
   - **wordpress_host**: Otra instancia t2.micro idéntica pero sin la instalación de Ansible, destinada a alojar WordPress

Ambas instancias comparten la misma AMI (ami-0c02fb55956c7d316) y tipo de instancia (t2.micro), y están etiquetadas con nombres descriptivos ("Ansible Host" y "WordPress Host").

Esta configuración proporciona la base para luego usar Ansible (desde ansible_host) para configurar automáticamente WordPress en wordpress_host, aprovechando que ambas instancias comparten el mismo security group que permite el tráfico necesario.

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow SSH and HTTP"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    description      = "Allow all outbound"
  }
}

resource "aws_instance" "ansible_host" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "AWS-Samuel"
  security_groups = [aws_security_group.wordpress_sg.name]
  tags = {
    Name = "Ansible Host"
  }

  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras enable ansible2
              yum install -y ansible
            EOF
}


resource "aws_instance" "wordpress_host" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "AWS-Samuel"
  security_groups = [aws_security_group.wordpress_sg.name]
  tags = {
    Name = "WordPress Host"
  }
}
