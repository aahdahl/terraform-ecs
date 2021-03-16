data aws_availability_zones available {}

variable name { type = string }
variable environment { type = string }

variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable private_cidr {
  type = string
  default = "10.0.0.0/18"
}

variable public_cidr {
  type = string
  default = "10.0.64.0/18"
}

locals {
  private_subnets = cidrsubnets(var.private_cidr, 2, 2, 2)
  public_subnets = cidrsubnets(var.public_cidr, 2, 2, 2)
}

resource aws_vpc main {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

resource aws_subnet private {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id
  cidr_block = local.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

resource aws_subnet public {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id
  cidr_block = local.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

resource aws_internet_gateway main {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

resource aws_security_group public {
  name = "${var.name}-${var.environment}-lb"
  vpc_id = aws_vpc.main.id
  description = "${var.name}-${var.environment}-external-sg"

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

output vpc_id {
  value = aws_vpc.main.id
}

output private_subnet_ids {
  value = aws_subnet.private[*].id
}
