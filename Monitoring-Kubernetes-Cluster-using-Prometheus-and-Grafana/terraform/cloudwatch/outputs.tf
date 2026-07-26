############################################################
# CloudWatch Outputs
############################################################

output "sns_topic_arn" {

  value = aws_sns_topic.eks_alerts.arn

}

output "dashboard_name" {

  value = aws_cloudwatch_dashboard.eks_dashboard.dashboard_name

}

output "cpu_alarm_name" {

  value = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name

}

############################################################
# Memory Alarm
############################################################

output "memory_alarm_name" {

  value = aws_cloudwatch_metric_alarm.memory_alarm.alarm_name

}