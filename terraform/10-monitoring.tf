# ========================================
# SNS para notificaciones por email
# ========================================

resource "aws_sns_topic" "alarm_notifications" {
  name = "wordpress-monitoring-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "ricardo.ramonpita@gmail.com" # "danimclum@gmail.com"
}

# ========================================
# CloudWatch Alarm - CPU Utilization (media del grupo)
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "NOTIFICACION-CPU-ALTO"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80 # Umbral
  alarm_description   = "CPU media del Auto Scaling Group > 80% durante 6 minutos"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# ========================================
# CloudWatch Alarm - Tráfico de red entrante alto (NetworkIn)
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_network_in_high" {
  alarm_name          = "NOTIFICACION-RED-ENTRANTE-ALTO"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10000000 # Umbral de 10 MB cada 2 minutos
  unit                = "Bytes"
  alarm_description   = "Red entrante alta en promedio del ASG"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# ========================================
# CloudWatch Alarm - Tráfico de red saliente alto (NetworkOut)
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_network_out_high" {
  alarm_name          = "NOTIFICACION-RED-SALIENTE-ALTO"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10000000 # 10 MB por periodo
  unit                = "Bytes"
  alarm_description   = "Red saliente alta en promedio del grupo"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}