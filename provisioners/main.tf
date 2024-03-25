provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = aws_vpc.vpc.cidr_block
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "gateway_route" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "rules" {
  name = "example"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name = "key"
  public_key = file("nginx_key.pub")
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "nginx" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.rules.id]
  key_name = aws_key_pair.keypair.key_name


  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo chmod 777 /usr/share/nginx/html/index.html",
      "echo \"Hello from nginx on AWS\" > /usr/share/nginx/html/index.html",
      "sudo systemctl start nginx",
    ]
  }

  connection {
    host = aws_instance.nginx.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("nginx_key")
  }
}

# It is better to avoid using provisoners, alternative to using proivisioners, would be usage of `user_data` provided by amazon

resource "aws_instance" "nginx" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.rules.id]
  key_name = aws_key_pair.keypair.key_name
  user_data = <<EOF
    #!/bin/bash
    set -ex

    yum update -y
    amazon-linux-extras enable nginx1.12
    yum -y install nginx
    chmod 777 /usr/share/nginx/html/index.html
    echo "Hello from nginx on AWS" > /usr/share/nginx/html/index.html
    systemctl start nginx
    
  EOF
}

# A null_resource is a special no-op resource that creates nothing. It is a dummy resource that allows you to attach a provisioner to it.
# This resource should be avoided unless necessary.

resource "null_resource" "setup" {
  provisioner "local-exec" {
    command = <<CMD
    ssh -i nginx_key ec2-user@${aws_instance.nginx.public_ip} -o StrictHostKeyChecki\
    ng=no -o UserKnownHostsFile=/dev/null 'sudo amazon-linux-extras enable nginx1.12; su\
    do yum -y install nginx; sudo chmod 777 /usr/share/nginx/html/index.html; echo \"Hel\
    lo from nginx on AWS\" > /usr/share/nginx/html/index.html; sudo systemctl start ngin\
    x;'
    CMD
  }
}

# To get this to work, though, you would have to put a delay into the script, otherwise,
# it will try to run the command before the server is ready to accept SSH connections.
# You would never use a null_resource for this. As we have explained, you would use user_data to configure an instance upon startup.