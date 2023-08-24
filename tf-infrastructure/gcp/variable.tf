variable "resource_name_prefix" {
  type = string
}

variable "org_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "billing_account" {
  type = string
}
variable "iam_roles" {
  type = set(string)
}
