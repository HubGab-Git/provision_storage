resource "aws_cloudwatch_metric_alarm" "instance" {
  alarm_name                = "cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.nebo_instance.id
  }
}

resource "aws_cloudwatch_metric_alarm" "s3" {
  alarm_name                = "all-requests"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "AllRequests"
  namespace                 = "AWS/S3"
  period                    = "120" #seconds
  statistic                 = "Maximum"
  threshold                 = "2"
  alarm_description         = "This metric monitors s3 all requests"
  insufficient_data_actions = []
  dimensions = {
    BucketName = aws_s3_bucket.nebo.id
    FilterId = aws_s3_bucket_metric.nebo.name
  }
}