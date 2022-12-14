resource "aws_sns_topic" "nebo" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.sns.json
}

resource "aws_sns_topic_subscription" "nebo" {
  topic_arn = aws_sns_topic.nebo.arn
  protocol  = "email"
  endpoint  = var.email
}