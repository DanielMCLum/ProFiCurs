# Define una configuración de inicio para las instancias EC2 de moodle
resource "aws_launch_template" "moodle_lt" {
    name_prefix   = "moodle_lt"
    image_id      = "ami-084568db4383264d4"
    instance_type = "t2.micro"
    key_name      = "Vokey"
    vpc_security_group_ids = [aws_security_group.sg_moodle.id]
    tags = {
        Name = "templade_moodle"
    }
}

# Define un Auto Scaling Group para las instancias de moodle
resource "aws_autoscaling_group" "moodle_asg" {
    name_prefix        = "moodle_asg"
    launch_template {
        id      = aws_launch_template.moodle_lt.id
        version = "$Latest"
    }
    vpc_zone_identifier = [aws_subnet.public1_moodle.id, aws_subnet.public2_moodle.id]
    desired_capacity   = 1
    min_size           = 1
    max_size           = 2
    health_check_type = "EC2"
}

#Creo politicas para el autoescalado.
resource "aws_autoscaling_policy" "moddle_p_asg" {
  name           = "cpu_scaling_policy"
  policy_type           = "TargetTrackingScaling"
  estimated_instance_warmup = 90
  autoscaling_group_name = aws_autoscaling_group.moodle_asg.name

  target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 75
    }
}