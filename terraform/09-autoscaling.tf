# ------------------------------------------------------------------------------
# CLOUDWATCH ALARM: CPU > 80% => ESCALAR HACIA ARRIBA
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-alarm"  # Nombre descriptivo para la alarma
  comparison_operator = "GreaterThanThreshold"  # Dispara si el valor es mayor al umbral
  evaluation_periods  = 2                # Número de períodos consecutivos evaluados
  metric_name         = "CPUUtilization" # Métrica de CPU de las instancias EC2
  namespace           = "AWS/EC2"        # Namespace correspondiente a EC2
  period              = 60               # Duración de cada período (en segundos)
  statistic           = "Average"        # Usa el promedio de CPU
  threshold           = 80               # Umbral: 80% de CPU
  alarm_description   = "Escala si CPU > 80%" # Descripción de la alarma

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
    # Relaciona la métrica con el grupo de autoescalado
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
    # Qué hacer si se dispara: invocar política de escalar hacia arriba
  ]
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"              # Nombre de la política
  policy_type            = "SimpleScaling"                 # Tipo de política simple
  scaling_adjustment     = 1                               # Aumentar 1 instancia
  adjustment_type        = "ChangeInCapacity"              # Cambiar cantidad de instancias
  cooldown               = 300                             # Esperar 5 minutos antes de volver a escalar
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name  # Grupo al que aplica
}

# ------------------------------------------------------------------------------
# CLOUDWATCH ALARM: CPU < 50% => ESCALAR HACIA ABAJO
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low-alarm"   # Nombre de la alarma
  comparison_operator = "LessThanThreshold" # Dispara si es menor al umbral
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50               # Umbral: 50% de CPU
  alarm_description   = "Reduce si CPU < 50%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
    # Acción: ejecutar la política que reduce instancias
  ]
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1                # Reducir en 1 instancia
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}
