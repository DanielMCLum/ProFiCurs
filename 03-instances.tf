# Define una configuración de inicio para las instancias EC2 de moodle
/*resource "aws_launch_template" "moodle_lt" {
    name_prefix   = "moodle_lt"
    image_id      = "ami-084568db4383264d4"
    instance_type = "t2.micro"
    key_name      = "Vokey"
    user_data = <<-EOF
        #!/bin/bash

        # Actualizar los repositorios
        sudo apt update -y

        # Instalar Apache2, PHP y extensiones necesarias para Moodle
        sudo apt install -y apache2 php libapache2-mod-php php-cli php-curl php-gd php-intl php-mbstring php-xml php-zip php-soap php-xmlrpc php-pgsql

        # Descargar la última versión estable de Moodle
        MOODLE_VERSION=$(wget -qO- https://download.moodle.org/latest.txt)
        wget https://download.moodle.org/download.php/direct/$MOODLE_VERSION/moodle-$MOODLE_VERSION.tgz

        # Crear el directorio de Moodle y descomprimir los archivos
        sudo mkdir -p /var/www/html/moodle
        sudo tar -xvzf moodle-$MOODLE_VERSION.tgz -C /var/www/html/
        sudo mv /var/www/html/moodle/moodle/* /var/www/html/moodle/
        sudo rm -rf /var/www/html/moodle/moodle/

        # Crear el directorio de datos de Moodle
        sudo mkdir -p /var/www/moodledata
        sudo chown -R www-data:www-data /var/www/moodledata
        sudo chmod -R 777 /var/www/moodledata

        # Establecer la propiedad de los archivos de Moodle al usuario de Apache
        sudo chown -R www-data:www-data /var/www/html/moodle

        # Eliminar el archivo descargado
        rm moodle-$MOODLE_VERSION.tgz

        # Opcional: Reiniciar Apache2
        sudo systemctl restart apache2

    EOF
    
    vpc_security_group_ids = [aws_security_group.sg_moodle.id]
    tags = {
        Name = "templade_moodle"
    }
}

# Define un Auto Scaling Group para las instancias de moodle
resource "aws_autoscaling_group" "moodle_asg" {
    name_prefix        = "moodle_asg"
    launch_template {
        id      = aws_launch_template.moodle_lt.id
        version = "$Latest"
    }
    vpc_zone_identifier = [aws_subnet.public1_moodle.id, aws_subnet.public2_moodle.id]
    desired_capacity   = 1
    min_size           = 1
    max_size           = 1
    health_check_type = "EC2"
}

# Creo politicas para el autoescalado.
resource "aws_autoscaling_policy" "moddle_p_asg" {
  name                      = "cpu_scaling_policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 90
  autoscaling_group_name    = aws_autoscaling_group.moodle_asg.name

  target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75
    }
}*/