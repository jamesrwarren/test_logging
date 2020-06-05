# TASK ROLE

resource "aws_iam_role" "lgtest" {
  assume_role_policy = data.aws_iam_policy_document.task_role_assume_policy.json
  name               = "app-lgtest-task-role-${local.environment}"
  tags               = local.default_tags
}

data "aws_iam_policy_document" "task_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "task_role" {
  policy = data.aws_iam_policy_document.task_role.json
  role   = aws_iam_role.lgtest.id
}

data "aws_iam_policy_document" "task_role" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
  }
}



# EXEC ROLE
resource "aws_iam_role" "execution_role" {
  name               = "app-lgtest-execution_role-${local.environment}"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume_policy.json
  tags               = local.default_tags
}

data "aws_iam_policy_document" "execution_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "execution_role" {
  policy = data.aws_iam_policy_document.execution_role.json
  role   = aws_iam_role.execution_role.id
}

data "aws_iam_policy_document" "execution_role" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue"
    ]
  }
}

resource "aws_iam_role" "get_app_secret" {
  assume_role_policy = data.aws_iam_policy_document.app_secret_role_assume_policy.json
  name               = "get-app-secret-${local.environment}"
  tags               = local.default_tags
}

data "aws_iam_policy_document" "app_secret_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {

      identifiers = local.account.allowed_access_app_secret
      type        = "AWS"
    }
  }
}

data "aws_iam_policy_document" "appsecretspolicy" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:eu-west-1:*:secret:applgtest_admin*",
      "arn:aws:secretsmanager:eu-west-1:*:secret:circle_token_url*",
      "arn:aws:secretsmanager:eu-west-1:*:secret:integrations_github_credentials*"
    ]

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
  }
}

resource "aws_iam_role_policy" "get_app_secret" {
  policy = data.aws_iam_policy_document.appsecretspolicy.json
  role   = aws_iam_role.get_app_secret.id
}

resource "aws_cloudwatch_log_group" "opg_app_lgtest" {
  name = local.environment
  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "standard" {
  name = "php-app-logs"
}

resource "aws_cloudwatch_log_group" "breakglass" {
  name = "php-app-logs-2"
}
