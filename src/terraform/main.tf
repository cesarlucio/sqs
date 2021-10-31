provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.44.0"
    }
  }
  backend "s3" {}
}
resource "aws_sqs_queue" "service_queue" {
  name                      = "${var.service_name}-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.service_dlq.arn
    maxReceiveCount     = 4
  })

  tags = var.resource_tags
}

resource "aws_sqs_queue" "service_dlq" {
  name                      = "${var.service_name}-dlq"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = var.resource_tags
}

locals {
  queue = concat(aws_sqs_queue.service_dlq.*)[0]
}
