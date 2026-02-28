variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "DevSecOps-RG"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
  default     = "East US"
}

variable "cluster_name" {
  type        = string
  default     = "Secure-AKS-Cluster"
}

variable "acr_name" {
  type        = string
  description = "Must be globally unique, alphanumeric only"
}