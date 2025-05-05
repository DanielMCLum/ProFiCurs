packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable client_id {
  default = "af0954fb-f306-467c-861f-1911497a71aa"
}
variable client_secret {
  default = "BS_8Q~nZ1vGDsnGagu2H5MqKUoLW1ZSsOTUi_bm~"
}

variable subscription_id {
  type    = string
  default = "9c83b4e6-cccc-4027-b0b1-3c6ff5807320" # Sigue siendo el mismo subscription_id
}

variable tenant_id {
  default = "836f1d43-90b9-41eb-815f-6e37bd65ff30" # Actualizado con el nuevo tenant_id
}

variable location {
  default = "westeurope"
}

variable "image_resource_group_name" {
  description = "Name of the resource group in which the Packer image will be created"
  default     = "myPackerImages2"
}

variable "oidc_request_url" {
  default = null
}

variable "oidc_request_token" {
  default = null
}

# arm builder
source "azure-arm" "builder" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_offer     = "UbuntuServer"
  image_publisher = "Canonical"
  image_sku       = "18_04-lts-gen2" # Actualiza a Ubuntu 18.04 LTS
  image_version   = "18.04.202401161"
  location                          = var.location
  managed_image_name                = "myPackerImage2"
  managed_image_resource_group_name = var.image_resource_group_name
  os_type                           = "Linux"
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  # oidc_request_url                  = var.oidc_request_url
  # oidc_request_token                = var.oidc_request_token
  vm_size                           = "Standard_DS2_v2"
  azure_tags = {
    "dept" : "Engineering",
    "task" : "Image deployment",
  }
}

variable "db_name" {
  description = "Nombre de la base de datos para WordPress"
  default     = "wordpress"
}

variable "db_user" {
  description = "Nombre del usuario de MySQL para WordPress"
  default     = "wordpressuser"
}

variable "db_password" {
  description = "Contraseña del usuario de MySQL para WordPress"
  default     = "MiContraseñaSegura123!"
}

build {
  sources = ["source.azure-arm.builder"]
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      # Preconfigurar MySQL para evitar interacciones interactivas
      "echo 'mysql-server mysql-server/root_password password rootpassword' | sudo debconf-set-selections",
      "echo 'mysql-server mysql-server/root_password_again password rootpassword' | sudo debconf-set-selections",

      # Evitar problemas con debconf (frontend no interactivo)
      "export DEBIAN_FRONTEND=noninteractive",

      # Actualizar paquetes e instalar dependencias
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y nginx mysql-server php-fpm php-mysql",

      # Configurar MySQL
      "systemctl start mysql",
      "mysql -e \"CREATE DATABASE wordpress;\"",
      "mysql -e \"CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'MiContraseñaSegura123!';\"",
      "mysql -e \"GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';\"",
      "mysql -e \"FLUSH PRIVILEGES;\"",

      # Descargar y configurar WordPress
      "wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz",
      "tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html",
      "chown -R www-data:www-data /var/www/html/wordpress",
      "chmod -R 755 /var/www/html/wordpress",

      # Configurar el archivo wp-config.php
      "cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php",
      "sed -i 's/database_name_here/wordpress/' /var/www/html/wordpress/wp-config.php",
      "sed -i 's/username_here/wordpressuser/' /var/www/html/wordpress/wp-config.php",
      "sed -i 's/password_here/MiContraseñaSegura123!/' /var/www/html/wordpress/wp-config.php",

      # Reiniciar servicios
      "systemctl enable nginx",
      "systemctl enable mysql",
      "systemctl restart nginx",
      "systemctl restart mysql",

      # Deprovisionar la máquina virtual
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}

