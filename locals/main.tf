/**
* A local is Terraform’s representation of a normal programming language variable.
* Confusingly, Terraform also has a concept called a variable which is really
* an input (variables are covered in the variables chapter). A local can refer to a fixed value such as a string,
* or it can be used to refer to an expression such as two other locals concatenated together.
*/

provider "aws" {
  region = "eu-west-1"
}

locals {
  first_part = "hello"
  second_part = "${local.first_part}-there"
  bucket_name = "${local.second_part}-how-are-you-today"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
}
