provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Crear el grupo de recursos
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Obtener la red virtual existente
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

# Obtener las subredes existentes
data "azurerm_subnet" "subnet_db" {
  name                 = var.db_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "subnet_backup" {
  name                 = var.backup_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

# Crear el NSG
module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = var.nsg_name
}

# VM de base de datos
module "db_vm" {
  source              = "./modules/vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = var.db_vm_name
  subnet_id           = data.azurerm_subnet.subnet_db.id
  vm_size             = var.db_vm_size
  nsg_id              = module.nsg.nsg_id
}

# VM de backup
module "backup_vm" {
  source              = "./modules/vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = var.backup_vm_name
  subnet_id           = data.azurerm_subnet.subnet_backup.id
  vm_size             = var.backup_vm_size
  nsg_id              = module.nsg.nsg_id
  public_ip           = var.public_ip
}

# Módulo de Load Balancer
module "load_balancer" {
  source              = "./modules/load_balancer"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "palonsoACR"
  resource_group_name = azurerm_resource_group.main.name
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
