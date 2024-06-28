variable "name" {
  description = "The name of the VM"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "nsg_id" {
  description = "The ID of the network security group"
  type        = string
}

variable "public_ip" {
  description = "Boolean to create a public IP"
  type        = bool
  default     = false
}
