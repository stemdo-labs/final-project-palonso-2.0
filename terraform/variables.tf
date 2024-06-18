variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
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
  description = "List of subnet CIDR prefixes"
  type        = list(string)
}

variable "db_vm_name" {
  description = "The name of the DB VM"
  type        = string
}

variable "db_vm_size" {
  description = "The size of the DB VM"
  type        = string
}

variable "backup_vm_name" {
  description = "The name of the Backup VM"
  type        = string
}

variable "backup_vm_size" {
  description = "The size of the Backup VM"
  type        = string
}

variable "default_node_pool_name" {
  description = "The default node pool name"
  type        = string
}

variable "default_node_pool_vm_size" {
  description = "The VM size for the default node pool"
  type        = string
}

variable "default_node_pool_min_count" {
  description = "The minimum count for the default node pool"
  type        = number
}

variable "default_node_pool_max_count" {
  description = "The maximum count for the default node pool"
  type        = number
}
variable "aks_resource_group_name" {
  description = "The name of the resource group where the AKS cluster is deployed"
  type        = string
  default     = "MC_rg-palonso-dvfinlab_aks-cluster_westeurope"
}