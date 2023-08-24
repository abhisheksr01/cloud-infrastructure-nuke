variable "resource_name_prefix" {
  type = string
}

variable "infrabackend_storage_account_name" {
  type = string
}

variable "infrabackend_storage_account_container_names" {
  type = set(string)
}

variable "storage_account_account_tier" {
  type = string
}

variable "storage_account_replication_type" {
  type = string
}

variable "location" {
  type = string
}

variable "role_assigned" {
  type = string

}

variable "githubactions_oidc" {
  type = object({
    description = string
    audiences   = list(string)
    issuer      = string
    subject     = string
  })
}
# Tags
variable "default_tags" {
  type = object({
    Owner       = string
    Team        = string
    Description = string
    Github      = string
    Provisioner = string
  })
}
