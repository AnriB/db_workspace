resource "azurerm_databricks_workspace" "workspace" {
    name                        = var.workspace_name
    resource_group_name         = var.resource_group_name
    location                    = var.location
    sku                         = var.databricks_sku
    managed_resource_group_name = var.managed_resource_group_name
    
    tags = var.tags
}