data aws_availability_zones available {}

data aws_ssm_parameter ecs_optimized_ami {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

resource aws_launch_configuration ecs_optimized {
  name = "${var.name}-${var.environment}"
  image_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value).image_id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config"
  security_groups = [aws_security_group.ecs_sg.id]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "systek"
}

resource aws_autoscaling_group main {
  name = "${var.name}-${var.environment}"
  desired_capacity = 1
  max_size = 1
  min_size = 1
  launch_configuration = aws_launch_configuration.ecs_optimized.name
  vpc_zone_identifier = var.private_subnet_ids
  health_check_type = "EC2"
}

