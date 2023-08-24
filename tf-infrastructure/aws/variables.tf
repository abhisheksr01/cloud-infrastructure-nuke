variable "remote_backend_name" {
  type        = string
  description = "S3 backend bucket for storing state of state of aws nuke repo"
}

variable "aws_nuke_resource_name_prefix" {
  type        = string
  description = "aws nuke resource name prefix followed by specific resource name"
}

variable "owner" {
  type        = string
  description = "creator or team who owns the resources"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "environment_name" {
  type        = string
  description = "Environment name"
}

variable "description" {
  type        = string
  description = "description of the aws resources"
}

# variable "access_delegated_aws_accounts" {
#   type        = list(string)
#   description = "list of AWS Account the role can sts assume role"
# }
