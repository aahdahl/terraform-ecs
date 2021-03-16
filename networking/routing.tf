resource aws_route_table public {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource aws_route_table_association public {
  count = length(local.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource aws_route_table private {
  vpc_id = aws_vpc.main.id
  # TODO: Remove this and replace with NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource aws_route_table_association private {
  count = length(local.private_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.private[count.index].id
}
