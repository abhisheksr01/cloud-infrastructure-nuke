module "gcs_buckets" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 4.0"
  project_id      = google_project.gcp_projects_nuke.project_id
  names           = ["bucket", ]
  prefix          = var.resource_name_prefix
  set_admin_roles = false
  versioning = {
    first = true
  }
}
