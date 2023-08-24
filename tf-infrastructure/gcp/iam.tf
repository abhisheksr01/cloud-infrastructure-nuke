resource "google_service_account" "gcp_projects_nuke_sa" {
  account_id   = "${var.resource_name_prefix}-sa"
  display_name = "${var.resource_name_prefix}-sa"
  project      = google_project.gcp_projects_nuke.name
}

resource "google_organization_iam_member" "organization" {
  org_id   = var.org_id
  for_each = var.iam_roles
  role     = each.value
  member   = "serviceAccount:${google_service_account.gcp_projects_nuke_sa.email}"
}
