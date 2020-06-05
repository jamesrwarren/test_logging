locals {
  app_definition = jsonencode({
    "cpu" : 10,
    "essential" : true,
    "image" : "995199299616.dkr.ecr.eu-west-1.amazonaws.com/jimmy:1.0",
    "mountPoints" : [],
    "name" : "lgtest_app",
    "portMappings" = [],
    "volumesFrom" = [],
    "logConfiguration" = {
      "logDriver" = "awslogs",
      "options" = {
        "awslogs-group"         = aws_cloudwatch_log_group.opg_app_lgtest.name,
        "awslogs-region"        = "eu-west-1",
        "awslogs-stream-prefix" = aws_iam_role.lgtest.name
      }
    }
  })

  default_tags = {
    business-unit          = "JIM"
  }

  database_username = "lgtestuser"
  database_name     = "applgtest"
  app_admin        = "admin"
  app_readonly     = "readonly"
  a_name_record     = "applgtest"

  environment = terraform.workspace
  account     = contains(keys(var.accounts), local.environment) ? var.accounts[local.environment] : var.accounts.development
}
