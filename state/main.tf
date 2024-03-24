# To import the VPC you created into Terraform, go to the AWS UI and copy the VPC ID. Go to the command line and type:
# > terraform import aws_vpc.example <VPC_ID>
# > terraform import <resource_type>.<resource_identifier> <value>

# To remove the VPC from the Terraform’s state, we need to use the terraform state rm command.
# This command needs to be handled with care. To remove the VPC from the state, run
# > terraform state rm aws_vpc.my_vpc

# There is another way to move a resource from one project to another, which is to use the terraform state mv command.
# > terraform state mv -state-out=../state_example_02a/terraform.tfstate aws_vpc.main aws_vpc.my_vpc

/**
* An import works a bit differently on the back end. Terraform queries the API of the infrastructure to read
* the resource and uses that to build the state. On the other hand, the move command copies the state across directly.
* The advantage of the state mv command is that it works on any resource, even if it does not support an import.
*/

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}
 