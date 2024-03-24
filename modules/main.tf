provider "aws" {
  region = "eu-west-1"
}

module "work_queue" {
  source = "./sqs-with-backoff"
  queue_name = "work-queue"
}

output "work_queue_name" {
  value = module.work_queue.queue_name
}

output "work_queue_dead_letter_name" {
  value = module.work_queue.dead_letter_queue_name
}

# Show the whole resource

output "work_queue" {
  value = module.work_queue.queue
}

output "work_queue_dead_letter_queue" {
  value = module.work_queue.dead_letter_queue
}

# Modules with submodules

resource "aws_security_group" "group_1" {
  name = "security group 1"
}

resource "aws_security_group" "group_2" {
  name = "security group 2"
}

resource "aws_security_group" "group_3" {
  name = "security group 3"
}

module "cross_talk_groups" {
  source            = "./cross-talk-3-way"
  security_group_1  = aws_security_group.group_1
  security_group_2  = aws_security_group.group_2
  security_group_3  = aws_security_group.group_3
  port              = 8500
  protocol          = "tcp"
}

# We also can use remote modules

module "remote_work_queue" {
  source = "github.com/kevholditch/sqs-with-backoff?ref=0.0.2"
  queue_name = "remote-work-queue"
}

output "remote_work_queue" {
  value = module.remote_work_queue.queue
}

output "remote_work_queue_dead_letter_queue" {
  value = module.remote_work_queue.dead_letter_queue
}