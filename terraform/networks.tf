/*====
Subnets
======*/
/* Internet gateway for the public subnet */
data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_eip" "nat" {
  vpc   = true
  count = 3
}

resource "aws_nat_gateway" "nat" {
  count         = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = data.aws_subnet.private[count.index].id

  tags                     = local.default_tags
}

data "aws_subnet" "private" {
  count             = 3
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  filter {
    name   = "tag:name"
    values = ["private*"]
  }
}

# resource "aws_subnet" "private" {
#   count             = 3
#   vpc_id            = data.aws_vpc.default.id
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   filter {
#     name   = "tag:Name"
#     values = ["private*"]
#   }
# }
