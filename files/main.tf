/**
* We have seen in the locals chapter how you can place a multi-line string as a value for a property.
* This is useful for something like an IAM policy. It can be even cleaner to move the value out
* into a file and then reference that file from your project. Doing this may remove the clutter from
* your project and make it much more readable.
*/

provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_policy" "my_bucket_policy" {
  name = "list-buckets-policy"
  policy = file("./policy.iam")
}

# The templatefile function allows us to define placeholders in a template file and then pass their values at runtime.

locals {
  rendered = templatefile("./example.tpl", { name = "kevin", number = 7})
}

output "rendered_template" {
  value = local.rendered
}

# You can pass in an array of values into a template and loop through them.

output "rendered_loop_template" {
  value = templatefile("./backends.tpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
}
