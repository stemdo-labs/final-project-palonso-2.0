
variable "aks_resource_group_name" {
  description = "The name of the resource group where the AKS cluster is deployed"
  type        = string
  default     = "MC_rg-palonso-dvfinlab_aks-cluster_westeurope"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

