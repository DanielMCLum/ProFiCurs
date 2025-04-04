provider "aws" {
  region = "us-east-1" # Puedes cambiar la región
}



# Configurar VPC y subred
resource "aws_vpc" "wordpress_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "wordpress-vpc"
  }
}

resource "aws_subnet" "wordpress_subnet" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" # Asegurarse que sea una zona válida en tu región

  tags = {
    Name = "wordpress-subnet"
  }
}

resource "aws_internet_gateway" "wordpress_gw" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wordpress-gw"
  }
}

resource "aws_route_table" "wordpress_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_gw.id
  }

  tags = {
    Name = "wordpress-rt"
  }
}

resource "aws_route_table_association" "wordpress_rta" {
  subnet_id      = aws_subnet.wordpress_subnet.id
  route_table_id = aws_route_table.wordpress_rt.id
}




# Grupo de Seguridad
resource "aws_security_group" "wordpress_sg" {
  vpc_id = aws_vpc.wordpress_vpc.id

  # Permitir tráfico HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfico SSH (para acceso remoto, se puede restringir a nuestra IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Se puede cambiar esto a nuestra IP en vez de 0.0.0.0/0 por seguridad
  }

  # Salida sin restricciones
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}



# Crear instancia EC2

resource "aws_instance" "wordpress_instance" {
  ami                    = "ami-0f9de6e2d2f067fca" # Ubuntu 22.04
  instance_type          = "t2.micro"              # Gratis en nuestra cuenta de AWS 
  subnet_id              = aws_subnet.wordpress_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  key_name               = "vockey" # Utilizamos el nombre de nuestro par de claves SSH

  /*
user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2 php libapache2-mod-php php-mysql mysql-server unzip wget

    # Habilitar y arrancar servicios
    sudo systemctl enable apache2
    sudo systemctl start apache2
    sudo systemctl enable mysql
    sudo systemctl start mysql

    # Configurar MySQL: Crear base de datos y usuario para WordPress
    sudo mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    sudo mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost';"
    sudo mysql -e "FLUSH PRIVILEGES;"

    # Descargar y configurar WordPress
    cd /var/www/html
    sudo wget https://wordpress.org/latest.zip
    sudo unzip latest.zip
    sudo mv wordpress/* .
    sudo rmdir wordpress
    sudo rm latest.zip
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R 755 /var/www/html

    # Configurar Apache para que sirva index.php primero
    sudo sed -i 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|' /etc/apache2/mods-enabled/dir.conf

    # Configurar WordPress con la base de datos automáticamente
    sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
    sudo sed -i "s/username_here/admin/" /var/www/html/wp-config.php
    sudo sed -i "s/password_here/admin/" /var/www/html/wp-config.php


    # Reiniciar Apache
    sudo systemctl restart apache2
  EOF
*/

  tags = {
    Name = "WordPress-Server"
  }

}


resource "local_file" "ansible_inventory" {
  content = <<EOF
  [wordpress]
  ${aws_instance.wordpress_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/vockey.pem
  EOF

  filename = "${path.module}/ansible/inventory"
}

