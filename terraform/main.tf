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
  subnet_names        = var.subnet_names
  subnet_prefixes     = var.subnet_prefixes
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
  subnet_id           = module.network.subnet_ids[1]
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

# Módulo de AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "k8s-${random_string.suffix.result}"

  default_node_pool {
    name                = var.default_node_pool_name
    vm_size             = var.default_node_pool_vm_size
    enable_auto_scaling = true
    min_count           = var.default_node_pool_min_count
    max_count           = var.default_node_pool_max_count
    vnet_subnet_id      = module.network.subnet_ids[1]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  sku_tier = "Standard"

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = "10.2.0.0/16"
    dns_service_ip    = "10.2.0.10"
  }
}

# Generar un sufijo aleatorio para el DNS prefix
resource "random_string" "suffix" {
  length  = 8
  special = false
}



# Output for backup VM public IP
output "backup_vm_public_ip" {
  value = module.backup_vm.public_ip
}
output "load_balancer_public_ip" {
  value = module.load_balancer.load_balancer_public_ip
}