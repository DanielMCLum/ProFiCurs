# Módulo de red: Define la infraestructura de red, incluyendo VNet y subredes.
module "network" {
  source              = "./modules/network"
  vnet_name           = "wordpress-vnet"   # Nombre de la VNet
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]    # Rango de direcciones de la red
  public_subnet_name  = "public-subnet"   # Nombre de la subred pública
  public_subnet_prefix = ["10.0.1.0/24"]  # Prefijo de la subred pública
  private_subnet_name = "private-subnet"  # Nombre de la subred privada
  private_subnet_prefix = ["10.0.2.0/24"] # Prefijo de la subred privada
}

# Módulo de cómputo: Gestiona instancias de máquinas virtuales.
module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.public_subnet_id # Asigna la VM a la subred pública
  vm_size             = var.vm_size                     # Tamaño de la VM
  instance_count      = var.instance_count              # Cantidad de instancias
  admin_username      = var.admin_username             # Usuario administrador
  admin_password      = var.admin_password             # Contraseña administrador
}

# Módulo de base de datos: Configura la base de datos para la aplicación.
module "database" {
  source              = "./modules/database"
  resource_group_name = var.resource_group_name
  location            = var.location
  db_name             = "wordpress-db"   # Nombre de la base de datos
  db_sku              = "B_Gen5_2"       # SKU de la base de datos
  storage_mb          = 5120             # Tamaño de almacenamiento en MB
  admin_username      = var.admin_username # Usuario administrador de la BD
  admin_password      = var.admin_password # Contraseña de la BD
}

# Módulo de seguridad: Gestiona configuraciones de seguridad y acceso.
module "security" {
  source              = "./modules/security"
  resource_group_name = var.resource_group_name
  location            = var.location
  vmss_id             = module.compute.vmss_id # ID de las máquinas virtuales gestionadas
}


