/**
* Output in your Terraform project shows a piece of data after Terraform successfully completes.
* Outputs are useful as they allow you to echo values from the Terraform run to the command line.
* For example, if you are creating an environment and setting up a bastion jump box as part of that environment,
* it’s handy to be able to echo the public IP address of the newly created bastion to the command line.
* Then, after the terraform apply finishes, you are given the IP of the newly created bastion which is
* ready for you to ssh straight onto it.
*/

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "first_bucket" {
  bucket = "gloompi-bucket-outputs"
}

output "bucket_name" {
  value = aws_s3_bucket.first_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.first_bucket.arn
}

output "bucket_information" {
  value = "bucket name: ${aws_s3_bucket.first_bucket.id}, bucket arn: ${aws_s3_bucket.first_bucket.arn}"
}

# Terraform allows you to output an entire resource or data block.
output "all" {
  value = aws_s3_bucket.first_bucket
}