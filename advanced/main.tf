provider "aws" {
  region = "eu-west-1"
}

locals {
  fruit = toset(["apple", "orange", "banana"])
}

resource "aws_sqs_queue" "for_queues" {
  for_each = local.fruit
  name = "queue-${each.key}"
}

resource "aws_sqs_queue" "queues" {
  count = 4
  name = "queue-${count.index}"
}

output "queue-apple-name" {
  value = aws_sqs_queue.for_queues["apple"].name
}

output "queue-0-name" {
  value = aws_sqs_queue.queues[0].name
}

## Lifecycle

resource "aws_sqs_queue" "queue" {
  name = "queue"

  lifecycle {
    create_before_destroy = false # Setting this property means that, as long as the backend API allows, Terraform will create the new resource before it destroys the old one
    prevent_destroy = true # Setting this property will stop Terraform from destroying a resource as long as the property remains set.
  }
}

## Depends on

resource "aws_iam_role_policy" "policy" {
  name = "policy"
  role = "role"
  policy = jsonencode({
    "Statement" = [{
      "Action" = "s3:*",
      "Effect" = "Allow",
    }],
  })
}

resource "aws_instance" "example" {
  ami = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  depends_on = [
    aws_iam_role_policy.policy, # Explicitly creating a dependancy
  ]
}
