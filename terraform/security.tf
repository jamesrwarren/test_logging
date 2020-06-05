/*====
ECS Task Security Group
======*/
resource "aws_security_group" "ecs_service" {
  vpc_id      = data.aws_vpc.default.id
  name        = "applgtest-ecs-service-sg"
  description = "Permissions from ECS"

  tags = local.default_tags
}

resource "aws_security_group_rule" "ecs_icmp" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "web_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_service.id
  cidr_blocks       = ["0.0.0.0/0"]
}


# LOADBALANCER STUFF








# resource "aws_security_group_rule" "ecs_app_ingress" {
#   type                     = "ingress"
#   from_port                = 9292
#   to_port                  = 9292
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.ecs_service.id
#   source_security_group_id = aws_security_group.web_facing.id
# }

/*====
Application Loadbalancer Security Group
======*/
# resource "aws_security_group" "web_facing" {
#   name        = "applgtest-web-inbound-sg"
#   description = "Allow HTTP from Anywhere into ALB"
#   vpc_id      = data.aws_vpc.default.id

#   tags = local.default_tags
# }

# resource "aws_security_group_rule" "web_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.web_facing.id
# }

# resource "aws_security_group_rule" "web_icmp" {
#   type              = "ingress"
#   from_port         = 8
#   to_port           = 0
#   protocol          = "icmp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.web_facing.id
# }



/*====
Database Security Groups
======*/
/* Security Group for resources that want to access the Database */
# resource "aws_security_group" "rds_sg" {
#   name        = "applgtest-rds-sg"
#   description = "sandbox Security Group"
#   vpc_id      = data.aws_vpc.default.id
#   tags        = local.default_tags

#   // allows traffic from the SG itself
# }

# resource "aws_security_group_rule" "rds_self" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   self              = true
#   security_group_id = aws_security_group.rds_sg.id
# }

# resource "aws_security_group_rule" "rds_db_ingress" {
#   type                     = "ingress"
#   from_port                = 5432
#   to_port                  = 5432
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.rds_sg.id
#   source_security_group_id = aws_security_group.db_access_sg.id
# }

# resource "aws_security_group_rule" "rds_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.rds_sg.id
# }


# /* Security Group to add to resources that want to access the Database */
# resource "aws_security_group" "db_access_sg" {
#   vpc_id      = data.aws_vpc.default.id
#   name        = "applgtest-db-access-sg"
#   description = "Allow access to RDS"

#   tags = local.default_tags
# }
