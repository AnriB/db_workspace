resource "azurerm_databricks_workspace" "workspace" {
  name                                  = var.workspace_name
  resource_group_name                   = var.resource_group_name
  location                              = var.location
  sku                                   = var.databricks_sku
  managed_resource_group_name           = var.managed_resource_group_name
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.network_security_group_rules_required
  tags                                  = var.tags
}

### User management ###

# Assign admin permissions to specified groups
resource "databricks_mws_permission_assignement" "admins" {
  for_each     = var.admins
  workspace_id = azurerm_databricks_workspace.workspace.id
  principal_id = data.databricks_group.admins[each.value].id
  permissions  = ["ADMIN"]
}

# Assign user permissions to specified groups
resource "databricks_mws_permission_assignement" "users" {
  for_each     = var.users
  workspace_id = azurerm_databricks_workspace.workspace.id
  principal_id = data.databricks_group.users[each.value].id
  permissions  = ["USER"]
}
