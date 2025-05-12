# 🚀 Proyecto: Despliegue de WordPress en Azure con Terraform y Packer

Este proyecto automatiza el despliegue de **WordPress** en **Azure**, utilizando **Terraform** para la infraestructura y **Packer** para la creación de una imagen personalizada de máquina virtual.

## 📌 Requisitos previos

Antes de ejecutar este código, asegúrate de tener:

- Una cuenta de **Azure** con permisos suficientes.
- **Terraform** y **Packer** instalados en tu sistema.
- Variables definidas en archivos `.tfvars` y `.pkrvars.hcl` (para credenciales seguras).
- Un archivo `.gitignore` para evitar subir información sensible.

## 📂 Estructura del proyecto

```plaintext
📂 wordpress-azure
 ├── terraform/
 │   ├── main.tf                 # Infraestructura principal
 │   ├── provider.tf             # Configuración del proveedor de Azure
 │   ├── variables.tf            # Definición de variables
 │   ├── terraform.tfvars        # Valores sensibles (NO subir a GitHub)
 │   ├── outputs.tf              # Variables de salida
 │   ├── .gitignore              # Archivos a excluir del repositorio
 │   ├── README.md               # Documentación de Terraform
 ├── packer/
 │   ├── packer.pkr.hcl          # Configuración de Packer
 │   ├── variables.pkr.hcl       # Definición de variables
 │   ├── packer.auto.pkrvars.hcl # Valores sensibles (NO subir a GitHub)
 │   ├── README.md               # Documentación de Packer
 ├── README.md                   # Documentación general del proyecto
🏗️ Infraestructura desplegada con Terraform
Grupo de recursos
Define el grupo de recursos donde se alojarán todos los servicios.

hcl
resource "azurerm_resource_group" "example" {
  name     = "wordpressResourceGroup"
  location = "eastus"
}
Red virtual y subred
Se define una red virtual con una subred.

hcl
resource "azurerm_virtual_network" "example" {
  name                = "wordpressVNet"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "wordpressSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
Máquina virtual
Se despliega una VM con una imagen personalizada creada con Packer.

hcl
resource "azurerm_virtual_machine" "example" {
  name                  = "wordpressVM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "wordpressOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    id = "/subscriptions/9c83b4e6-cccc-4027-b0b1-3c6ff5807320/resourceGroups/MYPACKERIMAGES2/providers/Microsoft.Compute/images/myPackerImage2"
  }

  os_profile {
    computer_name  = "wordpressVM"
    admin_username = "adminuser"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
Outputs
Después del despliegue, Terraform mostrará la siguiente información:

hcl
output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}
Para obtener la IP pública de la VM, ejecuta:

sh
terraform output vm_public_ip
🏗️ Creación de imagen con Packer
Configuración del builder
Se usa Packer para crear una imagen de máquina virtual con WordPress preinstalado.

hcl
source "azure-arm" "builder" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  location                          = var.location
  managed_image_name                = "myPackerImage2"
  managed_image_resource_group_name = var.image_resource_group_name
  os_type                           = "Linux"
  image_publisher                   = "Canonical"
  image_offer                       = "UbuntuServer"
  image_sku                         = "18_04-lts-gen2"
  image_version                      = "18.04.202401161"
  vm_size                           = "Standard_DS2_v2"
}
Provisionamiento
Se instala WordPress, MySQL y Nginx en la imagen.

hcl
provisioner "shell" {
  inline = [
    "apt-get update",
    "apt-get upgrade -y",
    "apt-get install -y nginx mysql-server php-fpm php-mysql",

    # Configurar MySQL
    "systemctl start mysql",
    "mysql -e \"CREATE DATABASE ${var.db_name};\"",
    "mysql -e \"CREATE USER '${var.db_user}'@'localhost' IDENTIFIED BY '${var.db_password}';\"",
    "mysql -e \"GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'localhost';\"",
    "mysql -e \"FLUSH PRIVILEGES;\"",

    # Descargar y configurar WordPress
    "wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz",
    "tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html",
    "chown -R www-data:www-data /var/www/html/wordpress",
    "chmod -R 755 /var/www/html/wordpress",

    # Configurar wp-config.php
    "cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php",
    "sed -i 's/database_name_here/${var.db_name}/' /var/www/html/wordpress/wp-config.php",
    "sed -i 's/username_here/${var.db_user}/' /var/www/html/wordpress/wp-config.php",
    "sed -i 's/password_here/${var.db_password}/' /var/www/html/wordpress/wp-config.php",

    # Reiniciar servicios
    "systemctl restart nginx",
    "systemctl restart mysql"
  ]
}
🚀 Despliegue
Terraform
Para desplegar la infraestructura:

sh
terraform init
terraform plan
terraform apply -auto-approve
Packer
Para construir la imagen de máquina virtual:

sh
packer init .
packer build .
🔐 Seguridad y buenas prácticas
✅ No exponer credenciales en variables.tf o packer.pkr.hcl → Usa terraform.tfvars y packer.auto.pkrvars.hcl. ✅ Añadir terraform.tfvars y packer.auto.pkrvars.hcl a .gitignore → Evita que se suban al repositorio. ✅ Usar variables en lugar de valores fijos → Evita riesgos de seguridad.

📌 Conclusión
Este proyecto permite desplegar WordPress en Azure de manera eficiente y segura, utilizando Terraform para la infraestructura y Packer para la imagen de VM. 🚀
