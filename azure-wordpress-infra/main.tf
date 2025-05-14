module "network" {
  source              = "./modules/network"
  vnet_name           = "wordpress-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  public_subnet_name  = "public-subnet"
  public_subnet_prefix = ["10.0.1.0/24"]
  private_subnet_name = "private-subnet"
  private_subnet_prefix = ["10.0.2.0/24"]
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.public_subnet_id
  vm_size             = var.vm_size
  instance_count      = var.instance_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "database" {
  source              = "./modules/database"
  resource_group_name = var.resource_group_name
  location            = var.location
  db_name             = "wordpress-db"
  db_sku              = "B_Gen5_2"
  storage_mb          = 5120
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "security" {
  source              = "./modules/security"
  resource_group_name = var.resource_group_name
  location            = var.location
  vmss_id             = module.compute.vmss_id
}

