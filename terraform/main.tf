provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/deployer-key.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH, HTTP, and HTTPS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "ubuntu-web-server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/hosts_ip.txt"
  }
}
