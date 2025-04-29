resource "aws_security_group" "sg_moodle" {
    name_prefix = "SG_moodle"
    vpc_id      = aws_vpc.vpc_moodle.id
    ingress {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "Permitir trafico SSH"
      
    }
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Permitir trafico HTTP"
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Permitir trafico HTTPS"
    }

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

resource "aws_security_group" "sg_rds_moodle" {
    vpc_id = aws_vpc.vpc_moodle.id
    
    ingress {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = ["${aws_security_group.sg_moodle.id}"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "Permisos de la BD"
    }
}

resource "aws_db_subnet_group" "grp_rds_moodle" {
    subnet_ids = ["${aws_subnet.private1_moodle.id}", "${aws_subnet.private2_moodle.id}"]
}