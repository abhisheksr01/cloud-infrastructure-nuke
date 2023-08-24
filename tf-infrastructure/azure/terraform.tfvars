resource_name_prefix                         = "az-resourcegroup-nuke"
infrabackend_storage_account_name            = "azrgnuke"
infrabackend_storage_account_container_names = ["terraform"]
storage_account_account_tier                 = "Standard"
storage_account_replication_type             = "LRS"
location                                     = "UK South"
role_assigned                                = "Contributor"
githubactions_oidc = {
  description = "This Federated credentials are used for authenticating the Github Actions pipeline for Azure Nuke in https://github.com/abhisheksr01/cloud-infrastructure-nuke"
  audiences   = ["api://AzureADTokenExchange"]
  issuer      = "https://token.actions.githubusercontent.com"
  subject     = "repo:abhisheksr01/cloud-infrastructure-nuke:ref:refs/heads/main"
}
default_tags = {
  Owner       = "Abhishek Rajput"
  Team        = "Cloud Cost Maintainence"
  Description = "Resources for Azure Resource Groups Nuke"
  Github      = "https://github.com/abhisheksr01/cloud-infrastructure-nuke"
  Provisioner = "Terraform"
}
