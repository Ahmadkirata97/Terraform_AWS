resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.terraform_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.terraform_queue.arn
}