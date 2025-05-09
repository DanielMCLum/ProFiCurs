# Target Group para las instancias WordPress
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# ALB
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false
}

# Listener HTTP (puerto 80) - Redirige a HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# Registrar instancias WordPress en el target group
resource "aws_lb_target_group_attachment" "wordpress_instances" {
  count            = length(aws_instance.wordpress)
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress[count.index].id
  port             = 80
}

