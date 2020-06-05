# resource "aws_secretsmanager_secret" "database_password" {
#   name = "applgtest_database"
# }

# data "aws_secretsmanager_secret_version" "database_password" {
#   secret_id = aws_secretsmanager_secret.database_password.id
# }

# resource "aws_secretsmanager_secret" "admin_password" {
#   name = "applgtest_admin"
# }

# resource "aws_secretsmanager_secret" "readonly_password" {
#   name = "applgtest_readonly"
# }

# resource "aws_secretsmanager_secret" "circle_url_token" {
#   name = "circle_token_url"
# }

# resource "aws_secretsmanager_secret" "integrations_github_credentials" {
#   name = "integrations_github_credentials"
# }
