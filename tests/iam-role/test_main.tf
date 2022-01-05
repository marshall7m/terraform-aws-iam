provider "aws" {}
module "mut_iam_role" {
  source = "../../modules/iam-role"

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