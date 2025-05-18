# --- Launch Template para Autoescalado ---
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-launch-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.wordpress_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress-asg"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group para Auto Scaling (aws_lb_target_group.wordpress_tg)

# Auto Scaling Group
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnets.default.ids
  health_check_type    = "ELB"

  target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_instance" "wordpress" {
#   count                       = 2
#   ami                         = var.ami_id
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.deployer.key_name
#   vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "wordpress-${count.index}"
#   }
# }

