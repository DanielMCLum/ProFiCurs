# Creamos el balanceador y el grupo de balance
resource "aws_lb" "moodle_lb" {
    name               = "moodle-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg_moodle.id]
    subnets            = [aws_subnet.public1_moodle.id, aws_subnet.public2_moodle.id]

    enable_deletion_protection = false

    tags = {
        Environment = "Production"
        Name        = "moodle-alb"
    }
}

resource "aws_lb_target_group" "moodle_tg" {
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc_moodle.id
    health_check {
        path     = "/"
        protocol = "HTTP"
        matcher  = "200"
        interval = 30
        timeout  = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = {
        Environment = "Production"
        Name        = "moodle-target-group"
    }
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.moodle_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.moodle_tg.arn
    }
}

# Asociamos el Target Group al Auto Scaling Group
resource "aws_autoscaling_attachment" "asg_attachment_alb" {
    autoscaling_group_name = aws_autoscaling_group.moodle_asg.name
    lb_target_group_arn    = aws_lb_target_group.moodle_tg.arn
}