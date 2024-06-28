variable "location" {
  description = "The Azure region where resources will be deployed"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "rg-palonso"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  default     = "vnet-common-bootcamp"
}

variable "vnet_cidr" {
  description = "The CIDR block for the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "The name of the subnet"
  default     = "sn-palonso"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.0.26.0/24"
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
  default     = false
}

variable "nsg_id" {
  description = "The ID of the network security group"
  default     = null
}
