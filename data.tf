data "databricks_group" "admins" {
  for_each     = toset(var.admins)
  display_name = each.value
}

data "databricks_group" "users" {
  for_each     = toset(var.users)
  display_name = each.value
}
