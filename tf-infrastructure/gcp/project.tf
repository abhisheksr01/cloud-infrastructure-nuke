resource "google_project" "gcp_projects_nuke" {
  name                = var.resource_name_prefix
  project_id          = var.resource_name_prefix
  folder_id           = data.google_folder.software.name
  billing_account     = var.billing_account
  auto_create_network = false
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.3"

  project_id = google_project.gcp_projects_nuke.project_id

  activate_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

data "google_folder" "software" {
  folder = var.folder_id
}
