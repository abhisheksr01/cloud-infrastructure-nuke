module "s3_backend" {
  source               = "git::https://github.com/abhisheksr01/terraform-modules.git//aws/s3-backend"
  remote_backend_name  = var.remote_backend_name
  environment_name     = var.environment_name
  owner                = var.owner
  description          = var.description
  s3_kms_master_key_id = data.aws_kms_alias.aws_kms_s3_default_key.id
}

data "aws_kms_alias" "aws_kms_s3_default_key" {
  name = "alias/aws/s3"
}
