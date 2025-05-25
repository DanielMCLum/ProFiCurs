# --------------------------------------------
# PLANTILLA DE LANZAMIENTO PARA INSTANCIAS EC2
# --------------------------------------------
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-launch-"
  image_id      = var.ami_id                          # AMI a usar
  instance_type = var.instance_type                  # Tipo de instancia EC2
  key_name      = aws_key_pair.deployer.key_name     # Clave SSH para conexión

  # Script de inicialización: monta EFS automáticamente
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    efs_id     = aws_efs_file_system.wordpress.id
    aws_region = var.aws_region
  }))
  
  # Configuración de red
  network_interfaces {
    associate_public_ip_address = true               # Obtener IP pública automáticamente
    security_groups             = [aws_security_group.wordpress_sg.id]  # Grupo de seguridad
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress-asg"                         # Nombre visible en consola AWS
    }
  }

  lifecycle {
    create_before_destroy = true                     # Evita tiempo sin disponibilidad
  }
}

# --------------------------------------------
# AUTO SCALING GROUP (ASG)
# --------------------------------------------
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 2                           # Número inicial de instancias
  max_size             = 4                           # Máximo de instancias permitidas
  min_size             = 2                           # Mínimo de instancias funcionando
  
  # Subredes personalizadas (de nuestra VPC propia)
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
  
  health_check_type    = "ELB"                        # Tipo de chequeo (con ALB). Esto le dice al ASG que use los chequeos del balanceador de carga
  target_group_arns    = [aws_lb_target_group.wordpress_tg.arn]  # Grupo del ALB

  launch_template {
    id      = aws_launch_template.wordpress.id       # Plantilla de lanzamiento
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true                       # Aplica el tag a cada instancia
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --------------------------------------------
# POLÍTICA DE AUTO ESCALADO HACIA ARRIBA
# --------------------------------------------
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1                         # Aumentar 1 instancia
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 1200                       # Tiempo de espera antes de aplicar otro cambio
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

# ALARMA CLOUDWATCH PARA ESCALAR HACIA ARRIBA (CPU > 80%)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "ASG-CPU-ALTO"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 90                           # Si supera el 85%
  alarm_description   = "Uso de CPU elevado - Escalando instancias"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}



# --------------------------------------------
# POLÍTICA DE ESCALADO HACIA ABAJO
# --------------------------------------------
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1                        # Reducir 1 instancia
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

# ALARMA CLOUDWATCH PARA ESCALAR HACIA ABAJO (CPU < 50%)
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "ASG-CPU-BAJO"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20                           # Si baja del 20%
  alarm_description   = "Uso del CPU bajo - Disminuyendo instancias"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

