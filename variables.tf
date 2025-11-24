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
  description = "The SKU of the Databricks workspace."
  type        = string
  default     = "value"
}

variable "managed_resource_group_name" {
  description = "The name of the managed resource group for the Databricks workspace."
  type        = string
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
