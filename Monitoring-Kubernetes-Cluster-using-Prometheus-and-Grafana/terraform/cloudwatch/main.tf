############################################################
# CloudWatch Module
############################################################

locals {

  common_tags = {

    Project     = var.project_name

    Environment = var.environment

    ManagedBy   = "Terraform"

  }

}

############################################################
# SNS Topic
############################################################

resource "aws_sns_topic" "eks_alerts" {

  name = "${var.cluster_name}-alerts"

  tags = merge(

    local.common_tags,

    var.additional_tags

  )

}

############################################################
# Email Subscription
############################################################

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.eks_alerts.arn

  protocol = "email"

  endpoint = var.alarm_email

}

############################################################
# CloudWatch Dashboard
############################################################

resource "aws_cloudwatch_dashboard" "eks_dashboard" {

  dashboard_name = "${var.cluster_name}-dashboard"

  dashboard_body = jsonencode({

    widgets = [

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {

          title  = "Node CPU Utilization"

          region = var.aws_region

          view   = "timeSeries"

          metrics = [

            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.node_group_name
            ]

          ]

        }

      }

    ]

  })

}

############################################################
# CPU Alarm
############################################################

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {

  alarm_name = "${var.cluster_name}-HighCPU"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = var.cpu_threshold

  alarm_actions = [

    aws_sns_topic.eks_alerts.arn

  ]

}

############################################################
# Memory Alarm
############################################################

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {

  alarm_name = "${var.cluster_name}-HighMemory"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "mem_used_percent"

  namespace = "CWAgent"

  period = 300

  statistic = "Average"

  threshold = var.memory_threshold

  alarm_description = "High Memory Usage"

  alarm_actions = [

    aws_sns_topic.eks_alerts.arn

  ]

}