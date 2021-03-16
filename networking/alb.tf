resource aws_alb main {
  name = "${var.name}-${var.environment}"
  subnets = aws_subnet.public[*].id
  tags = {
    name = var.name
    environment = var.environment
    Name = "${var.name}-${var.environment}"
  }
}
