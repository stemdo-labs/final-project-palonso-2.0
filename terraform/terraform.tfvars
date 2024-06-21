
# Definir la ubicación de los recursos
location = "westeurope"
# Definir el nombre del grupo de recursos
resource_group_name = "rg-palonso-dvfinlab"

vnet_name           = "my-vnet"
vnet_cidr           = "10.0.0.0/16"
subnet_names        = ["db-subnet", "backup-subnet"]
subnet_prefixes     = ["10.0.2.0/24", "10.0.3.0/24"]
db_vm_name          = "db-vm"
db_vm_size          = "Standard_B1ms"
backup_vm_name      = "backup-vm"
backup_vm_size      = "Standard_B1ms"
default_node_pool_name = "aks"
default_node_pool_vm_size = "Standard_B2s"
default_node_pool_min_count = 1
default_node_pool_max_count = 3
