# ========================================
# SNS para notificaciones por email
# ========================================

resource "aws_sns_topic" "alarm_notifications" {
  name = "wordpress-monitoring-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "9797ricardo.ramonpita@gmail.com" # danimclum@gmail.com"
}

# ========================================
# CloudWatch Alarm - CPU Utilization (media del grupo)
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "ASG-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU media del Auto Scaling Group > 80% durante 6 minutos"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# ========================================
# CloudWatch Alarm - NetworkIn
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_network_in_high" {
  alarm_name          = "ASG-NetworkIn-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10000000 # 10 MB cada 2 minutos
  unit                = "Bytes"
  alarm_description   = "Red entrante alta en promedio del grupo"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# ========================================
# CloudWatch Alarm - NetworkOut
# ========================================

resource "aws_cloudwatch_metric_alarm" "asg_network_out_high" {
  alarm_name          = "ASG-NetworkOut-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10000000
  unit                = "Bytes"
  alarm_description   = "Red saliente alta en promedio del grupo"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}



/*
############## PARA EC2 fijas #####################
# SNS Topic para enviar notificaciones
resource "aws_sns_topic" "alarm_notifications" {
  name = "ec2-monitoring-alerts"
}

# Suscripción por email
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "danimclum@gmail.com"  # Recibirás un email para confirmar esta suscripción
}

# Monitorear uso de CPU alto por instancia
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  for_each = aws_instance.wordpress  # Solo si estas instancias existen
  alarm_name          = "CPUHigh-${each.value.tags["Name"]}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU > 80% durante 5 min"
  dimensions = {
    InstanceId = each.value.id
  }
  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# Monitorear tráfico de red entrante
resource "aws_cloudwatch_metric_alarm" "network_in_high" {
  for_each = aws_instance.wordpress
  alarm_name = "NetInHigh-${each.value.tags["Name"]}"
  ...
}

# Monitorear tráfico de red saliente
resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  for_each = aws_instance.wordpress
  alarm_name = "NetOutHigh-${each.value.tags["Name"]}"
  ...
}

*/