variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-devsecops-dev"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
  default     = "eastus"
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name"
  default     = "aks-devsecops-dev"
}

variable "acr_name" {
  type        = string
  description = "ACR name prefix — must be globally unique, alphanumeric only (random suffix appended)"
  default     = "acrdevsecops"
}
