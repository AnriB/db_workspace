# Network
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

# User mgmt
data "databricks_group" "admins" {
  for_each     = toset(var.admins)
  display_name = each.value
}

data "databricks_group" "users" {
  for_each     = toset(var.users)
  display_name = each.value
}

# DBFS encryption
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
