#!/bin/bash

# Actualizar e instalar paquetes necesarios
apt-get update -y
apt-get install -y nfs-common php php-fpm php-mysql curl rsync unzip

# Crear directorio si no existe
mkdir -p /var/www/html

# Montar EFS
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
  ${efs_id}.efs.${aws_region}.amazonaws.com:/ /var/www/html

# Establecer permisos correctos
chown -R www-data:www-data /var/www/html

# Iniciar y habilitar PHP-FPM
systemctl enable php8.1-fpm
systemctl start php8.1-fpm

# Instalar WordPress solo si no está
if [ ! -f /var/www/html/wp-config.php ]; then
  cd /tmp
  curl -O https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  rsync -a /tmp/wordpress/ /var/www/html/
  chown -R www-data:www-data /var/www/html
fi
