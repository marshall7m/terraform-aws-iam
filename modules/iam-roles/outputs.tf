output "roles" {
  value = { for name in var.roles[*].role_name : name => module.iam_role[name] }
}