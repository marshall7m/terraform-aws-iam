locals {
  account_id = 123456789012
}

module "mut_iam_account_roles" {
  source = "../../../modules//iam-account-roles"

  admin_role_cross_account_ids = [local.account_id]
  custom_admin_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  dev_role_cross_account_ids = [local.account_id]
  custom_dev_role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  read_role_cross_account_ids = [local.account_id]
  custom_read_role_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  tf_plan_role_cross_account_ids = [local.account_id]
  tf_plan_allowed_actions = [
    "tag:Get*",
    "s3:List*",
    "s3:Get*"
  ]
  tf_plan_allowed_resources = ["*"]

  tf_apply_role_cross_account_ids = [local.account_id]
  tf_apply_allowed_actions = [
    "s3:*"
  ]
  tf_apply_allowed_resources = ["*"]

  cd_role_cross_account_ids = [local.account_id]
  cd_statements = [
    {
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:GetApplicationRevision",
        "codedeploy:RegisterApplicationRevision"
      ]
    },
    {
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "s3:GetObject*",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
    }
  ]
}