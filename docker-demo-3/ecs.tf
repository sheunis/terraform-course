# cluster
resource "aws_ecs_cluster" "example-cluster" {
  name = "example-cluster"
}

# resource "aws_launch_configuration" "ecs-example-launchconfig" {
#   name_prefix          = "ecs-launchconfig"
#   image_id             = var.ECS_AMIS[var.AWS_REGION]
#   instance_type        = var.ECS_INSTANCE_TYPE
#   key_name             = aws_key_pair.mykeypair.key_name
#   iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
#   security_groups      = [aws_security_group.ecs-securitygroup.id]
#   user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_launch_template" "example-launch-template" { correct
#   name_prefix   = "example-launchtemplate"
#   image_id      = var.AMIS[var.AWS_REGION]
#   instance_type = "t2.micro"
#   key_name        = aws_key_pair.mykeypair.key_name
#   vpc_security_group_ids = [aws_security_group.myinstance.id]
#   user_data       = filebase64("${path.module}/scripts/init.sh")

#   instance_initiated_shutdown_behavior = "terminate"
# }

resource "aws_launch_template" "example-launch-template" {
  name_prefix   = "example-launchtemplate"
  image_id      = var.ECS_AMIS[var.AWS_REGION]
  instance_type = var.ECS_INSTANCE_TYPE
  key_name        = aws_key_pair.mykeypair.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs-ec2-role.name
  }
  vpc_security_group_ids = [aws_security_group.ecs-securitygroup.id]
  #vpc_security_group_ids = [aws_security_group.myinstance.id]
  user_data       = filebase64("${path.module}/scripts/init.sh")

  instance_initiated_shutdown_behavior = "terminate"
}

resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "ecs-example-autoscaling"
  vpc_zone_identifier  = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  min_size             = 1
  max_size             = 1

  launch_template {
    id = aws_launch_template.example-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}
