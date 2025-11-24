variable "workspace_name" {
  description = "The name of the Databricks workspace."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Databricks workspace."
  type        = string
}

variable "location" {
  description = "The Azure location where the Databricks workspace will be created."
  type        = string
}

variable "databricks_sku" {
  description = "The SKU of the Databricks workspace. From 2026 all Databricks workspaces will default to 'premium'."
  type        = string
  default     = "premium"
}

variable "managed_resource_group_name" {
  description = "The name of the managed resource group for the Databricks workspace."
  type        = string
}

variable "customer_managed_key_enabled" {
  description = "Enable or disable customer managed keys for the Databricks workspace."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the Databricks workspace."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access for the Databricks workspace."
  type        = bool
  default     = false
}

variable "network_security_group_rules_required" {
  description = "Indicates whether network security group rules are required for the Databricks workspace."
  type        = string
  default     = "AllRules"
}

variable "vnet_resource_group_name" {
  description = "The name of the resource group where the existing virtual network is located."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the existing virtual network to associate with the Databricks workspace."
  type        = string
}

variable "public_subnet_name" {
  description = "The name of the public subnet within the virtual network."
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the private subnet within the virtual network."
  type        = string
}

variable "admins" {
  description = "A list of Databricks admin group display names."
  type        = list(string)
  default     = []
}

variable "users" {
  description = "A list of Databricks user group display names."
  type        = list(string)
  default     = []
}

variable "key_vault_name" {
  description = "The name of the Key Vault for DBFS encryption."
  type        = string
}
