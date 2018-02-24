data "aws_region" "current" {}

resource "aws_sns_topic" "jenkins-watch" {
  name  = "jenkins-watch"
  display_name = "Jenkins monitoring"
}

resource "null_resource" "jenkins-watch-alerts-subscription" {
  depends_on = ["aws_sns_topic.jenkins-watch"]

  provisioner "local-exec" {
    command = <<CMD
      aws sns subscribe \
        --topic-arn ${aws_sns_topic.jenkins-watch.arn} \
        --protocol email \
        --notification-endpoint ${var.NOTIFICATION_ENDPOINT} \
        --profile ${var.DEFAULT_PROFILE} \
        --region ${data.aws_region.current.name}
CMD
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-alb-no-healthy-hosts" {
  depends_on = ["aws_alb.jenkins-lb"]

  alarm_name = "Jenkins in ${var.AWS_REGION} ALB: No healthy hosts"
  alarm_description = "No healthy hosts for Jenkins master"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "HealthyHostCount"
  namespace = "AWS/ApplicationELB"
  statistic = "Average"
  period = "60"
  evaluation_periods = "1"
  unit = "Count"
  threshold = "0"
  comparison_operator = "LessThanOrEqualToThreshold"

  dimensions {
    LoadBalancer = "${aws_alb.jenkins-lb.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-alb-4xx-errors" {
  depends_on = ["aws_alb.jenkins-lb"]

  alarm_name = "Jenkins in ${var.AWS_REGION} ALB: 4XX ERRORS"
  alarm_description = "No healthy hosts for Jenkins master"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "HTTPCode_ELB_4XX_Count"
  namespace = "AWS/ApplicationELB"
  statistic = "Sum"
  period = "60"
  evaluation_periods = "1"
  unit = "Count"
  threshold = "0"
  comparison_operator = "GreaterThanThreshold"

  dimensions {
    LoadBalancer = "${aws_alb.jenkins-lb.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-alb-5xx-errors" {
  depends_on = ["aws_alb.jenkins-lb"]

  alarm_name = "Jenkins in ${var.AWS_REGION} ALB: 5XX ERRORS"
  alarm_description = "No healthy hosts for Jenkins master"
  actions_enabled= "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "HTTPCode_ELB_5XX_Count"
  namespace = "AWS/ApplicationELB"
  statistic = "Sum"
  period = "60"
  evaluation_periods = "1"
  unit = "Count"
  threshold = "0"
  comparison_operator = "GreaterThanThreshold"

  dimensions {
    LoadBalancer = "${aws_alb.jenkins-lb.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-ec2-credits" {
  depends_on = ["aws_instance.ec2-jenkins"]

  alarm_name = "Jenkins in ${var.AWS_REGION} EC2: No Credits"
  alarm_description = "No credits for Jenkins master"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "CPUCreditBalance"
  namespace = "AWS/EC2"
  statistic = "Average"
  period = "120"
  evaluation_periods = "10"

  threshold = "200"
  comparison_operator = "LessThanOrEqualToThreshold"

  dimensions {
    InstanceId = "${aws_instance.ec2-jenkins.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-ec2-cpu-loads" {
  depends_on = ["aws_instance.ec2-jenkins"]

  alarm_name = "Jenkins in ${var.AWS_REGION} EC2: CPU Load"
  alarm_description = "High Load for CPU Jenkins master"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  statistic = "Average"
  period = "120"
  evaluation_periods = "10"

  threshold = "80"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions {
    InstanceId = "${aws_instance.ec2-jenkins.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-ec2-ebs-burstbalance" {
  depends_on = ["aws_ebs_volume.ebs-volume-1"]

  alarm_name = "Jenkins EBS in ${var.AWS_REGION}: BurstBalance"
  alarm_description = "BurstBalance for EBS"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "BurstBalance"
  namespace = "AWS/EBS"
  statistic = "Average"
  period = "120"
  evaluation_periods = "10"

  threshold = "40"
  comparison_operator = "LessThanOrEqualToThreshold"

  dimensions {
    VolumeId = "${aws_ebs_volume.ebs-volume-1.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-ec2-ebs-volume-queue-lenght" {
  depends_on = ["aws_ebs_volume.ebs-volume-1"]

  alarm_name = "Jenkins EBS in ${var.AWS_REGION}: VolumeQueueLength"
  alarm_description = "VolumeQueueLength for EBS"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  ok_actions = ["${aws_sns_topic.jenkins-watch.arn}"]
  metric_name = "VolumeQueueLength"
  namespace = "AWS/EBS"
  statistic = "Average"
  period = "120"
  evaluation_periods = "10"

  threshold = "30"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions {
    VolumeId = "${aws_ebs_volume.ebs-volume-1.id}"
  }
}
