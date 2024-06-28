provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Módulo de NSG
module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "default-nsg"
}

# Módulo de red
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_cidr           = var.vnet_cidr
  subnet_names        = [var.subnet_name]
  subnet_prefixes     = [var.subnet_cidr]
}

# VM de base de datos
module "db_vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.db_vm_name
  subnet_id           = module.network.subnet_ids[0]
  vm_size             = var.db_vm_size
  nsg_id              = module.nsg.nsg_id
}

# VM de backup
module "backup_vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.backup_vm_name
  subnet_id           = module.network.subnet_ids[0]  # Ajustado para la misma subred
  vm_size             = var.backup_vm_size
  nsg_id              = module.nsg.nsg_id
  public_ip           = true
}

# Módulo de Load Balancer
module "load_balancer" {
  source              = "./modules/load_balancer"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "palonsoACR"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Outputs
output "backup_vm_public_ip" {
  value = module.backup_vm.public_ip
}

output "load_balancer_public_ip" {
  value = module.load_balancer.load_balancer_public_ip
}
