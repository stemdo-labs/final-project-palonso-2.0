# Definir la ubicación de los recursos
location = "uksouth"

# Definir el nombre del grupo de recursos
resource_group_name = "rg-palonso"

# Definir el nombre de la VNet común
vnet_name = "vnet-common-bootcamp"

# Definir el nombre del grupo de recursos de la VNet
vnet_resource_group_name = "final-project-common"

# Definir el nombre de las subredes
db_subnet_name = "sn-palonso"
backup_subnet_name = "sn-palonso"

# Nombres y tamaños de las VMs
db_vm_name     = "db-vm"
db_vm_size     = "Standard_B1ms"
backup_vm_name = "backup-vm"
backup_vm_size = "Standard_B1ms"

# Configuración de IP pública
public_ip = true

# Nombre del NSG
nsg_name = "default-nsg"
