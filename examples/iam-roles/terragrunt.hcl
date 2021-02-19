include {
    path = find_in_parent_folders("aws.hcl")
}

terraform {
    source = "../../modules//iam-roles"
}

inputs = {
    roles = [
        {
            role_name = "foo-role"
            statements = [
                {
                    effect = "Allow"
                    actions = ["s3:GetObject"]
                    resources = ["*"]
                },
                {
                    effect = "Allow"
                    actions = ["s3:PutObject"]
                    resources = ["*"]
                }
            ]
        }
    ]
}