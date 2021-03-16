resource aws_ecs_cluster main {
  name = "${var.name}-${var.environment}"
  tags = {
    Name = "${var.name}-${var.environment}"
    name = var.name
    environment = var.environment
  }
}
