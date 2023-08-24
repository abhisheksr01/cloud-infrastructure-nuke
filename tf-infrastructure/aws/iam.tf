resource "aws_iam_group" "cross_account_admin" {
  name = "cross-account-admin-access-delegator-group"
}

# Below code must be refractored
resource "aws_iam_group_policy" "aws_nuke_se_practices_sts_policy" {
  name  = "se-practices-account-admin-access-sts-policy"
  group = aws_iam_group.cross_account_admin.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::1234567890123:role/${var.aws_nuke_resource_name_prefix}-admin-role"
      },
    ]
  })
}

resource "aws_iam_group_policy" "aws_nuke_training_sts_policy" {
  name  = "training-account-admin-access-sts-policy"
  group = aws_iam_group.cross_account_admin.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.aws_nuke_admin_role.arn
      },
    ]
  })
}

resource "aws_iam_group_policy" "sts_policy" {
  name  = "sts-assume-policy"
  group = aws_iam_group.cross_account_admin.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::*:role/*"
      }
    ]
  })
}
resource "aws_iam_user" "aws_nuke_user" {

  name = "${var.aws_nuke_resource_name_prefix}-user"
  path = "/system/"

  tags = {
    Terraform   = true
    Owner       = var.owner
    Environment = var.environment_name
    Description = var.description
  }
}

resource "aws_iam_role" "aws_nuke_admin_role" {
  name = "aws-nuke-access-delegator-admin-role"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action    = "sts:AssumeRole"
          Condition = {}
          Effect    = "Allow"
          Principal = {
            AWS = "arn:aws:iam::1234567890:root"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  tags = {
    Terraform   = true
    Owner       = var.owner
    Environment = var.environment_name
    Description = var.description
  }
}
resource "aws_iam_group_membership" "cross-account-group-membership" {
  name = "cross-account-admin-access-delegator-group-membership"

  users = [
    aws_iam_user.aws_nuke_user.name,
  ]

  group = aws_iam_group.cross_account_admin.name
}
