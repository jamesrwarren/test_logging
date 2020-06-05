resource "aws_ecs_cluster" "lgtest" {
  name = "app-lgtest"
}

resource "aws_ecs_task_definition" "lgtest" {
  family                   = "app-lgtest"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = "[${local.app_definition}]"
  task_role_arn            = aws_iam_role.lgtest.arn
  execution_role_arn       = aws_iam_role.execution_role.arn
  tags                     = local.default_tags
}

resource "aws_ecs_service" "lgtest" {
  name                    = aws_ecs_task_definition.lgtest.family
  cluster                 = aws_ecs_cluster.lgtest.id
  task_definition         = aws_ecs_task_definition.lgtest.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_service.id]
    subnets          = data.aws_subnet.private.*.id
    assign_public_ip = true
  }

  tags       = local.default_tags
}
