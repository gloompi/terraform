/**
* A variable in Terraform is something that can be set at runtime.
* It allows you to vary what Terraform will do by passing in or using a dynamic value.
*/

# We can set variables in command line `terraform apply -var bucket_suffix=hello`
# Or by env variables `export TF_VAR_bucket_name=<your-bucketname>`

provider "aws" {
  region = "eu-west-1"
}

variable "bucket_name" {
  description = "the name of the bucket you wish to create"
}

variable "bucket_suffix" {
  default = "-some-suffix"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}${var.bucket_suffix}"
}

# We also can create `terraform.tfvars` and place env variables there, similar to `.env`
variable "instance_map" {}
variable "environment_type" {}

output "selected_instance" {
  value = var.instance_map[var.environment_type]
}

# We can specify types

## Simple types

variable "a" {
  type = string
  default = "foo"
}

variable "b" {
  type = bool
  default = true
}

output "a" {
  value = var.a
}

output "b" {
  value = var.b
}

## List

variable "a" {
  type = list(string)
  default = ["foo", "bar", "baz"]
}

output "a" {
  value = var.a
}

output "b" {
  value = element(var.a, 1)
}

output "c" {
  value = length(var.a)
}

## Set

variable "my_set" {
  type = set(number)
  default = [7, 2, 2]
}

variable "my_list" {
  type = list(string)
  default = ["foo", "bar", "foo"]
}

output "set" {
  value = var.my_set
}

output "list" {
  value = var.my_list
}

output "list_as_set" {
  value = toset(var.my_list)
}

## Tuple

variable "my_tup" {
  type = tuple([number, string, bool])
  default = [4, "hello", false]
}

output "tup" {
  value = var.my_tup
}

## Map

variable "my_map" {
  type = map(number)
  default = {
    "alpha" = 2
    "bravo" = 3
  }
}

output "map" {
  value = var.my_map
}

output "alpha_value" {
  value = var.my_map["alpha"]
}

## Object

variable "person" {
  type = object({ name = string, age = number })
  default = {
    name = "Bob"
    age = 10
  }
}

output "person" {
  value = var.person
}

variable "person_with_address" {
  type = object({ name = string, age = number,
    address = object({ line1 = string, line2 = string, 
      county = string, postcode = string }) })

  default = {
    name = "Jim"
    age = 21
    address = {
      line1 = "1 the road"
      line2 = "St Ives"
      county = "Cambridgeshire"
      postcode = "CB1 2GB"
    }
  }
}

output "person_with_address" {
  value = var.person_with_address
}

## Any
### The any type is a special construct that serves as a placeholder for a type yet to be decided.
### any itself is not a type. Terraform will attempt to calculate the type at runtime when you use any.

variable "any_example" {
  type = any
  default = {
    field1 = "foo"
    field2 = "bar"
  }
}

output "any_example" {
  value = var.any_example
}
