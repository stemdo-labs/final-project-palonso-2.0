variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "default_node_pool_name" {
  description = "The name of the default node pool"
  type        = string
  default     = "default"
}

variable "default_node_pool_vm_size" {
  description = "The VM size for the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "default_node_pool_min_count" {
  description = "The minimum number of nodes for the default node pool"
  type        = number
  default     = 1
}

variable "default_node_pool_max_count" {
  description = "The maximum number of nodes for the default node pool"
  type        = number
  default     = 2
}
