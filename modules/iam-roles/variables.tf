
variable "roles" {
    description = "List of configurations for IAM roles (see `../iam-role` for attr description)"
    type = list(object({
        create_role = optional(bool)
        role_name = optional(string)
        role_path = optional(string)
        role_max_session_duration = optional(number)
        role_description = optional(string)
        role_force_detach_policies = optional(bool)
        role_permissions_boundary = optional(string)
        role_requires_mfa = optional(bool)
        role_mfa_age = optional(number)
        role_tags = optional(map(string))
        common_tags = optional(map(string))
        trusted_entities = optional(list(string))
        trusted_services = optional(list(string))
        allowed_resources = optional(list(string))
        allowed_actions = optional(list(string))
        role_conditions = optional(list(object({
            test     = string
            variable = string
            values   = list(string)
        })))
        statements = optional(list(object({
            effect    = string
            resources = list(string)
            actions   = list(string)
            conditions = optional(list(map(object({
                test     = string
                variable = string
                values   = list(string)
            }))))
        })))
        policy_name = optional(string)
        policy_description = optional(string)
        policy_path = optional(string)
        custom_role_policy_arns = optional(list(string))
    }))
}