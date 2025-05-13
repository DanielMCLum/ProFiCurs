
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow SSH and HTTP"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    description      = "Allow all outbound"
  }
}

resource "aws_instance" "ansible_host" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "AWS-Samuel"
  security_groups = [aws_security_group.wordpress_sg.name]
  tags = {
    Name = "Ansible Host"
  }

  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras enable ansible2
              yum install -y ansible
            EOF
}


resource "aws_instance" "wordpress_host" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "AWS-Samuel"
  security_groups = [aws_security_group.wordpress_sg.name]
  tags = {
    Name = "WordPress Host"
  }
}
