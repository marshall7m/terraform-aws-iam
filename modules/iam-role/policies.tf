locals {
  # TODO: Replace merge workaround when issue is fixed: https://github.com/hashicorp/terraform/issues/27385
  statements = [for statement in var.statements : merge(statement, { conditions = coalesce(statement.conditions, []) })]
}

data "aws_iam_policy_document" "permissions" {
  count = var.allowed_resources != null && var.allowed_actions != null || local.statements != [] ? 1 : 0
  dynamic "statement" {
    for_each = var.allowed_resources != null && var.allowed_actions != null ? [1] : []
    content {
      effect    = "Allow"
      resources = var.allowed_resources
      actions   = var.allowed_actions
    }
  }
  dynamic "statement" {
    for_each = local.statements
    content {
      effect    = statement.value.effect
      resources = statement.value.resources
      actions   = statement.value.actions
      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "permissions" {
  count       = var.allowed_resources != null && var.allowed_actions != null || local.statements != [] ? 1 : 0
  name        = var.policy_name != null ? var.policy_name : var.role_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.permissions[0].json
}

resource "aws_iam_role_policy_attachment" "permissions" {
  count = var.allowed_resources != null && var.allowed_actions != null || local.statements != [] ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_permissions" {
  count = length(var.custom_role_policy_arns) > 0 ? length(var.custom_role_policy_arns) : 0

  role       = aws_iam_role.this[0].name
  policy_arn = element(var.custom_role_policy_arns, count.index)
}

#### TRUST-POLICIES ####

data "aws_iam_policy_document" "assume_role_with_mfa" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_entities
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.role_mfa_age]
    }

    dynamic "condition" {
      for_each = var.role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }

  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.trusted_entities != [] ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_entities
      }
    }

    dynamic "principals" {
      for_each = var.trusted_services != [] ? [1] : []
      content {
        type        = "Service"
        identifiers = var.trusted_services
      }
    }

    dynamic "condition" {
      for_each = var.role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}