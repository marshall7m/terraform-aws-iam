# TODO: Replace coalesce workaround when issues: https://github.com/hashicorp/terraform/issues/27385
module "iam_role" {
    source = "../iam-role"
    for_each = { for role in var.roles: role.role_name => role }
    create_role = coalesce(each.value.create_role, true)
    role_name = each.value.role_name
    role_path = coalesce(each.value.role_path, "/")
    role_max_session_duration = coalesce(each.value.role_max_session_duration, 3600)
    role_description = coalesce(each.value.role_description, " ")
    role_force_detach_policies = coalesce(each.value.role_force_detach_policies, false)
    role_permissions_boundary = coalesce(each.value.role_permissions_boundary, " ")
    role_requires_mfa = coalesce(each.value.role_requires_mfa, false)
    role_mfa_age = coalesce(each.value.role_mfa_age, 86400)
    role_tags = coalesce(each.value.role_tags, {})
    common_tags = coalesce(each.value.common_tags, {})
    trusted_entities = coalesce(each.value.trusted_entities, [])
    trusted_services = coalesce(each.value.trusted_services, [])
    allowed_resources = coalesce(each.value.allowed_resources, [])
    allowed_actions = coalesce(each.value.allowed_actions, [])
    role_conditions = coalesce(each.value.role_conditions,[] )
    statements = coalesce(each.value.statements, [])
    policy_name = each.value.policy_name
    policy_description = coalesce(each.value.policy_description, " ")
    policy_path = coalesce(each.value.policy_path, "/")
    custom_role_policy_arns = coalesce(each.value.custom_role_policy_arns, [])
}