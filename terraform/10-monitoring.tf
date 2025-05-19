/*
resource "aws_sns_topic" "alarm_notifications" {
  name = "ec2-monitoring-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "danimclum@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  for_each = { for i in range(length(aws_instance.wordpress)) : i => aws_instance.wordpress[i] }
  alarm_name          = "EC2-CPU-High-${each.value.tags.Name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Average"
  threshold           = 80.0
  alarm_description   = "Alarma cuando la utilización de la CPU supera el 80% durante 5 minutos"
  dimensions = {
    InstanceId = each.value.id
  }
  alarm_actions = [
    aws_sns_topic.alarm_notifications.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "network_in_high" {
  for_each = { for i in range(length(aws_instance.wordpress)) : i => aws_instance.wordpress[i] }
  alarm_name          = "EC2-NetworkIn-High-${each.value.tags.Name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Average"
  threshold           = 10000000 # 10 MB por minuto 
  unit                = "Bytes/Second"
  alarm_description   = "Alarma cuando el tráfico de red entrante promedio supera los 10 MB/min durante 5 minutos"
  dimensions = {
    InstanceId = each.value.id
  }
  alarm_actions = [
    aws_sns_topic.alarm_notifications.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  for_each = { for i in range(length(aws_instance.wordpress)) : i => aws_instance.wordpress[i] }
  alarm_name          = "EC2-NetworkOut-High-${each.value.tags.Name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Average"
  threshold           = 10000000 # 10 MB por minuto
  unit                = "Bytes/Second"
  alarm_description   = "Alarma cuando el tráfico de red saliente promedio supera los 10 MB/min durante 5 minutos"
  dimensions = {
    InstanceId = each.value.id
  }
  alarm_actions = [
    aws_sns_topic.alarm_notifications.arn
  ]
}

*/