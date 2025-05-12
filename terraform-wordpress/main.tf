# ==========================================================
# 🚀 Configuración de WordPress en Azure con VM
# ==========================================================
# Este código Terraform despliega una infraestructura en Azure
# que incluye una máquina virtual, red, IP pública y almacenamiento.
# ==========================================================

# 1️⃣ Definición de proveedores requeridos
# ----------------------------------------
# Se usa el proveedor de Azure (`azurerm`) en su versión 3.x.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# 2️⃣ Configuración del proveedor de Azure
# ----------------------------------------
# Se define el proveedor de Azure con la suscripción correspondiente.
provider "azurerm" {
  features {}
  subscription_id = "9c83b4e6-cccc-4027-b0b1-3c6ff5807320" # Asegúrate de que este es tu ID de suscripción correcto
}

# 3️⃣ Creación del grupo de recursos
# ----------------------------------
# Se define un grupo de recursos en la región `East US`.
resource "azurerm_resource_group" "example" {
  name     = "wordpressResourceGroup"
  location = "eastus"
}

# 4️⃣ Creación de una IP pública
# ------------------------------
# Se asigna una IP pública estática para la máquina virtual.
resource "azurerm_public_ip" "example" {
  name                = "wordpressPublicIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

# 5️⃣ Creación de la red virtual
# ------------------------------
# Se define una red virtual con un espacio de direcciones.
resource "azurerm_virtual_network" "example" {
  name                = "wordpressVNet"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# 6️⃣ Creación de la subred
# -------------------------
# Se asigna una subred dentro de la red virtual.
resource "azurerm_subnet" "example" {
  name                 = "wordpressSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 7️⃣ Creación de la interfaz de red
# ----------------------------------
# Se configura la interfaz de red con IP pública y privada dinámica.
resource "azurerm_network_interface" "example" {
  name                = "wordpressNIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "wordpressNICConfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# 8️⃣ Creación de la máquina virtual
# ----------------------------------
# Se despliega una VM con una imagen personalizada y credenciales.
resource "azurerm_virtual_machine" "example" {
  name                  = "wordpressVM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s"  # Tamaño básico incluido en Azure for Students

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
    admin_password = "P@ssw0rd123!"  # ⚠️ ¡No expongas credenciales en el código!
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

