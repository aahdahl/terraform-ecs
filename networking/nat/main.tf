variable name { type = string }
variable environment { type = string }
variable subnet_id { type = string }

resource aws_eip nat {
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}

resource aws_nat_gateway main {
  allocation_id = aws_eip.nat.allocation_id
  subnet_id = var.subnet_id
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}
