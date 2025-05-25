# Grupo de destino al que el ALB enviará tráfico (por IP o por instancia EC2)
resource "aws_lb_target_group" "wordpress_tg" {
  name         = "wordpress-tg"
  port         = 80                         # Puerto que escucha el target group
  protocol     = "HTTP"                     # Protocolo del tráfico dirigido a las instancias
  vpc_id       = aws_vpc.main.id            # VPC en la que vive el grupo
  target_type  = "instance"                 # Se enruta tráfico a instancias EC2

  # Configuración de chequeo de salud
  health_check {
    path                = "/"             # Endpoint para verificar salud (ej. raíz del servidor web)
    interval            = 30              # Cada cuánto hacer el chequeo (segundos)
    timeout             = 5               # Cuánto esperar una respuesta antes de marcarla como fallida
    healthy_threshold   = 2               # Número de éxitos para marcar como saludable
    unhealthy_threshold = 2               # Número de fallos para marcar como no saludable
    matcher             = "200-399"       # Códigos HTTP considerados como exitosos
  }
}


# Application Load Balancer (ALB)
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false                               # "false" = accesible desde internet
  load_balancer_type = "application"                       # Tipo: ALB (no NLB)
  security_groups    = [aws_security_group.wordpress_sg.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_deletion_protection = false                       # Protege contra eliminación accidental
}

# Listeners (HTTP y HTTPS)
# Listener HTTP redirige a HTTPS automáticamente
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

# Listener HTTPS reenvía tráfico al grupo de destino
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn             # Certificado SSL/TLS de ACM

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}


/*
# Asocia manualmente instancias EC2 al target group
resource "aws_lb_target_group_attachment" "wordpress_instances" {
  count            = length(aws_instance.wordpress)              # Una por cada instancia creada
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress[count.index].id
  port             = 80
}
*/
