resource "aws_security_group" "sg_moodle" {
    name_prefix = "SG_moodle"
    vpc_id      = "aws_vpc.vpc_moodle.id"
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir tráfico HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir tráfico HTTPS"
  }

  /*ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["TU_IP_PUBLICA/32"] # Limita el acceso SSH
    description = "Permitir acceso SSH"
  }*/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_moodle"
  }
}