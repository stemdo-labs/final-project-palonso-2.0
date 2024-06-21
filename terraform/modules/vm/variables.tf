variable "name" {
  description = "The name of the VM"
  type        = string
}

variable "location" {
  description = "The location of the VM"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name of the VM"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the VM"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "nsg_id" {
  description = "The ID of the NSG to associate with the NIC"
  type        = string
}

variable "public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}