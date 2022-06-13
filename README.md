# Terraform AWS IAM

## Description

Terraform Module that provisions AWS resources for IAM services and entities

`modules/iam-role`: Creates an IAM role and associated IAM policies. The module can attach the appropriate policy to require MFA for assuming the role via the `var.role_requires_mfa` variable.

`modules/iam-account-roles`: Creates base AWS IAM account roles that can be assumed from other trusted AWS accounts. The module supports the following IAM roles:
- admin: Administrative privileges
- dev: Development privileges (usually overlaps with admin privileges except for IAM, organizations and account access)
- read: Read access
- tf_plan: Permissions needed for ci-cd services to run `terraform plan` within account
- tf_apply: Permissions needed for ci-cd services to run `terraform apply` within account
- cd: Permissions needed for cross account services to deploy applications within account

## Usage

`iam-role`

```
module "iam_role" {
  source = "github.com/marshall7m/terraform-aws-iam/modules//iam-role"

  role_name = "foo-role"
  statements = [
    {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["*"]
    }
  ]

  trusted_services = ["codebuild.amazonaws.com"]
}
```

`iam-account-roles`

```
module "iam_account_roles" {
  source = "github.com/marshall7m/terraform-aws-iam/modules//iam-account-roles"

  admin_role_cross_account_ids = [123456789012]
  custom_admin_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  dev_role_cross_account_ids = [123456789012]
  custom_dev_role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  read_role_cross_account_ids = [123456789012]
  custom_read_role_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  tf_plan_role_cross_account_ids = [123456789012]
  tf_plan_allowed_actions = [
    "tag:Get*",
    "s3:List*",
    "s3:Get*"
  ]
  tf_plan_allowed_resources = ["*"]

  tf_apply_role_cross_account_ids = [123456789012]
  tf_apply_allowed_actions = [
    "s3:*"
  ]
  tf_apply_allowed_resources = ["*"]

  cd_role_cross_account_ids = [123456789012]
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
```