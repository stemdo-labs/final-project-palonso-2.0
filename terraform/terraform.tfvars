# Definir la ubicación de los recursos
location = "westeurope"

# Definir el nombre del grupo de recursos
resource_group_name = "rg-palonso"

# Definir el nombre de la VNet común y su CIDR
vnet_name   = "vnet-common-bootcamp"
vnet_cidr   = "10.0.0.0/16"

# Definir el nombre de la subred y su CIDR
subnet_name   = "sn-palonso"
subnet_cidr   = "10.0.26.0/24"

# Nombres y tamaños de las VMs
db_vm_name     = "db-vm"
db_vm_size     = "Standard_B1ms"
backup_vm_name = "backup-vm"
backup_vm_size = "Standard_B1ms"
