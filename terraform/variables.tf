variable "location" {
  description = "The Azure region where resources will be deployed"
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "rg-palonso"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  default     = "vnet-common-bootcamp"
}

variable "vnet_resource_group_name" {
  description = "The name of the resource group where the virtual network is located"
  default     = "final-project-common"
}

variable "db_subnet_name" {
  description = "The name of the subnet for the database VM"
  default     = "sn-palonso"
}

variable "backup_subnet_name" {
  description = "The name of the subnet for the backup VM"
  default     = "sn-palonso"
}

variable "db_vm_name" {
  description = "The name of the database VM"
  default     = "db-vm"
}

variable "db_vm_size" {
  description = "The size of the database VM"
  default     = "Standard_B1ms"
}

variable "backup_vm_name" {
  description = "The name of the backup VM"
  default     = "backup-vm"
}

variable "backup_vm_size" {
  description = "The size of the backup VM"
  default     = "Standard_B1ms"
}

variable "public_ip" {
  description = "Boolean to create a public IP"
  default     = true
}

variable "nsg_name" {
  description = "The name of the network security group"
  default     = "default-nsg"
}
