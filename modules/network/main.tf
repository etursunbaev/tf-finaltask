resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.create_vpc ? var.create_vpc : false
  enable_dns_hostnames = var.create_vpc ? var.create_vpc : false
  tags = merge(var.additional_tags, {
    Name = var.vpc_name
    },
  )
}
resource "aws_subnet" "this_public" {
  count             = var.create_vpc ? length(var.public_subnets) : 0
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  tags = merge(var.additional_tags, {
    Name = format("public_%s", substr(element(var.azs, count.index), 9, 10))
    },
  )
}
resource "aws_subnet" "this_private" {
  count             = var.create_vpc ? length(var.private_subnets) : 0
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  tags = merge(var.additional_tags, {
    Name = format("private_%s", substr(element(var.azs, count.index), 9, 10))
    },
  )
}
resource "aws_subnet" "this_dbs" {
  count             = var.create_vpc ? length(var.database_subnets) : 0
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = element(concat(var.database_subnets, [""]), count.index)
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  tags = merge(var.additional_tags, {
    Name = format("private_db_%s", substr(element(var.azs, count.index), 9, 10))
    },
  )
}

resource "aws_internet_gateway" "this_igw" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this_vpc.id

  tags = merge(
    { "Name" = "cloudx-igw" },
    var.additional_tags,
  )
}

resource "aws_route_table" "public_rt" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this_vpc.id

  tags = merge(
    { "Name" = "public_rt" },
    var.additional_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private_rt" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this_vpc.id

  tags = merge(
    {
      "Name" = format("private_rt_%s", substr(element(var.azs, count.index), 9, 10))
    },
    var.additional_tags,
  )
}
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.this_public.*.id)
  subnet_id      = element(aws_subnet.this_public.*.id, count.index)
  route_table_id = aws_route_table.public_rt[0].id
}
resource "aws_route_table_association" "private" {
  count          = length(concat(aws_subnet.this_private.*.id, aws_subnet.this_dbs.*.id))
  subnet_id      = element(concat(aws_subnet.this_private.*.id, aws_subnet.this_dbs.*.id), count.index)
  route_table_id = aws_route_table.private_rt[0].id
}