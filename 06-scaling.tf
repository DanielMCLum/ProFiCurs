resource "aws_launch_configuration" "wordpress" {
    name            = "Minio-AutoScaling"
    image_id        = "ami-071226ecf16aa7d96"
    instance_type   = "t2.micro"
    key_name        = "Vokey"
    security_groups = [aws_security_group.sg_wordpress.id]
    iam_instance_profile        = "LabInstanceProfile"
}

resource "aws_autoscaling_group" "wordpress" {
    name                 = "wordpress-group"
    min_size             = 1
    max_size             = 2
    desired_capacity     = 2
    launch_configuration = aws_launch_configuration.wordpress.name
    vpc_zone_identifier  = [aws_subnet.public1.id, aws_subnet.public2.id]

    tag {
        key                 = "Name"
        value               = "Grupo-Escalado-WP"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "wordpress" {
    name           = "cpu-scaling-policy"
    policy_type           = "TargetTrackingScaling"
    estimated_instance_warmup = 200
    autoscaling_group_name = aws_autoscaling_group.wordpress.name

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75
    }
}