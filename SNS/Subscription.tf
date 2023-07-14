resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = "the arn of the topic we want"
  protocol  = "sqs"
  endpoint  = "the ARN of the Endpoint we want"
}