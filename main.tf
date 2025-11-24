resource "azurerm_databricks_workspace" "workspace" {
  name                                  = var.workspace_name
  resource_group_name                   = var.resource_group_name
  location                              = var.location
  sku                                   = var.databricks_sku
  managed_resource_group_name           = var.managed_resource_group_name
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.network_security_group_rules_required
  customer_managed_key_enabled          = var.customer_managed_key_enabled
  custom_parameters {
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = data.azurerm_subnet.public_subnet.id
    private_subnet_name                                  = var.private_subnet_name
    private_subnet_network_security_group_association_id = data.azurerm_subnet.private_subnet.id
    virtual_network_id                                   = data.azurerm_virtual_network.vnet.id
  }
  tags = var.tags
}

### User management ###

# Assign admin permissions to specified groups
resource "databricks_mws_permission_assignment" "admins" {
  for_each     = toset(var.admins)
  workspace_id = azurerm_databricks_workspace.workspace.id
  principal_id = data.databricks_group.admins[each.value].id
  permissions  = ["ADMIN"]
}

# Assign user permissions to specified groups
resource "databricks_mws_permission_assignment" "users" {
  for_each     = toset(var.users)
  workspace_id = azurerm_databricks_workspace.workspace.id
  principal_id = data.databricks_group.users[each.value].id
  permissions  = ["USER"]
}

### DBFS Encryption with Customer Managed Key ###
resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "managed_key" {
  for_each         = var.customer_managed_key_enabled ? { create = true } : {}
  depends_on       = [data.azurerm_client_config.current]
  workspace_id     = azurerm_databricks_workspace.workspace.id
  key_vault_key_id = azurerm_key_vault_key.dbfs["create"].id
}

resource "azurerm_key_vault_key" "dbfs" {
  for_each     = var.customer_managed_key_enabled ? { create = true } : {}
  name         = "dbfs-encryption-key"
  key_vault_id = data.azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
resource "azurerm_key_vault_access_policy" "terraform" {
  for_each     = var.customer_managed_key_enabled ? { create = true } : {}
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]
}

resource "azurerm_key_vault_access_policy" "databricks" {
  for_each     = var.customer_managed_key_enabled ? { create = true } : {}
  depends_on   = [azurerm_databricks_workspace.workspace]
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_databricks_workspace.workspace.identity[0].principal_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]
}
