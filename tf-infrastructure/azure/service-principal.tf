resource "azuread_application" "az_rg_nuke" {
  display_name = var.resource_name_prefix
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "az_rg_nuke" {
  application_id               = azuread_application.az_rg_nuke.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "az_rg_nuke" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_assigned
  principal_id         = azuread_service_principal.az_rg_nuke.object_id
}

resource "azuread_application_federated_identity_credential" "az_rg_nuke_oidc" {
  application_object_id = azuread_application.az_rg_nuke.object_id
  display_name          = "${var.resource_name_prefix}-githubactions-oidc"
  description           = var.githubactions_oidc.description
  audiences             = var.githubactions_oidc.audiences
  issuer                = var.githubactions_oidc.issuer
  subject               = var.githubactions_oidc.subject
}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}
