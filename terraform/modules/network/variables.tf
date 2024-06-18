variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be deployed"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_cidr" {
  description = "The CIDR block for the virtual network"
  type        = string
}

variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}
