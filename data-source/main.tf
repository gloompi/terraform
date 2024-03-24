/**
* A data source in Terraform is used to fetch data from a resource that is not managed by the current Terraform project.
* This allows it to be used in the current project. You can think of it as a read-only resource that already exists;
* the object exists, but you want to read specific properties of that object for use in your project.
*/
provider "aws" {
  region = "us-east-1"
}

data "aws_s3_bucket" "bucket" {
  bucket = "gloompi"
}

resource "aws_iam_policy" "gloompi_policy" {
  name = "gloompis-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.bucket.arn}"
      ]
    }
  ]
}
  POLICY
}