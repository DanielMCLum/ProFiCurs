# ==========================================================
# 🚀 Configuración de Packer para crear una imagen en Azure
# ==========================================================
# Este archivo define la configuración de Packer para generar
# una imagen de máquina virtual con WordPress preinstalado.
# ==========================================================

# 1️⃣ Definición de plugins requeridos
# ------------------------------------
# Se usa el plugin de Azure para Packer en su versión 2.x.
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

# 2️⃣ Configuración del builder de Packer
# ---------------------------------------
# Se define el builder de Azure para crear la imagen de máquina virtual.
source "azure-arm" "builder" {
  # 🔐 Autenticación en Azure
  # Se usan variables para evitar exponer credenciales en el código.
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id

  # 🌍 Ubicación y grupo de recursos
  # Define la región y el grupo de recursos donde se almacenará la imagen.
  location                          = var.location
  managed_image_name                = "myPackerImage2"
  managed_image_resource_group_name = var.image_resource_group_name

  # 🖥️ Configuración de la imagen
  # Se usa Ubuntu 18.04 LTS como sistema base.
  os_type                           = "Linux"
  image_publisher                   = "Canonical"
  image_offer                       = "UbuntuServer"
  image_sku                         = "18_04-lts-gen2"
  image_version                     = "18.04.202401161"

  # ⚙️ Tamaño de la VM temporal
  # Se usa una VM estándar para la creación de la imagen.
  vm_size                           = "Standard_DS2_v2"

  # 🏷️ Etiquetas en Azure
  # Se agregan etiquetas para identificar la imagen en Azure.
  azure_tags = {
    "dept" : "Engineering",
    "task" : "Image deployment"
  }
}

# 3️⃣ Provisionamiento de la imagen
# ---------------------------------
# Se instala WordPress y sus dependencias en la imagen.
build {
  sources = ["source.azure-arm.builder"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",

      # 📦 Actualizar paquetes e instalar dependencias
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y nginx mysql-server php-fpm php-mysql",

      # 🛡️ Configurar MySQL
      "systemctl start mysql",
      "mysql -e \"CREATE DATABASE ${var.db_name};\"",
      "mysql -e \"CREATE USER '${var.db_user}'@'localhost' IDENTIFIED BY '${var.db_password}';\"",
      "mysql -e \"GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'localhost';\"",
      "mysql -e \"FLUSH PRIVILEGES;\"",

      # 🌐 Descargar y configurar WordPress
      "wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz",
      "tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html",
      "chown -R www-data:www-data /var/www/html/wordpress",
      "chmod -R 755 /var/www/html/wordpress",

      # ⚙️ Configurar el archivo wp-config.php
      "cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php",
      "sed -i 's/database_name_here/${var.db_name}/' /var/www/html/wordpress/wp-config.php",
      "sed -i 's/username_here/${var.db_user}/' /var/www/html/wordpress/wp-config.php",
      "sed -i 's/password_here/${var.db_password}/' /var/www/html/wordpress/wp-config.php",

      # 🔄 Reiniciar servicios
      "systemctl enable nginx",
      "systemctl enable mysql",
      "systemctl restart nginx",
      "systemctl restart mysql",

      # 🧹 Deprovisionar la máquina virtual
      # Esto limpia la VM antes de convertirla en una imagen.
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}
