resource "azurerm_resource_group" "az_rg_nuke" {
  name     = var.resource_name_prefix
  location = var.location
  tags     = var.default_tags
}