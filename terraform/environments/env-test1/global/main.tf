provider "aws" {
  region = var.aws_region
}

module "tfcloud" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 2.0"

  name = "tfcloud.robot"

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

module "iam_group_superadmins" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 2.0"

  name = "superadmins"

  group_users = [
    module.tfcloud.this_iam_user_name,
  ]

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}










