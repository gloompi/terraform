output "queue_arn" {
  value = aws_sqs_queue.sqs.arn
}

output "queue_name" {
  value = aws_sqs_queue.sqs.name
}

output "dead_letter_queue_arn" {
  value = aws_sqs_queue.sqs_dead_letter.arn
}

output "dead_letter_queue_name" {
  value = aws_sqs_queue.sqs_dead_letter.name
}

# We also can return the whole resource back

output "queue" {
  value = aws_sqs_queue.sqs
}

output "dead_letter_queue" {
  value = aws_sqs_queue.sqs_dead_letter
}