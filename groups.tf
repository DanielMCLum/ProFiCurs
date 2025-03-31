#tabla de enrutamiento
resource "aws_route_table_association" "publica1" {
    subnet_id   = aws_subnet.publica1.id
    route_table_id = aws_route_table.publica.id
}

resource "aws_route_table_association" "publica2" {
    subnet_id   = aws_subnet.publica2.id
    route_table_id = aws_route_table.publica.id
}

resource "aws_route_table_association" "privada1" {
    subnet_id   = aws_subnet.privada1.id
    route_table_id = aws_route_table.privada.id
}

resource "aws_route_table_association" "publica2" {
    subnet_id   = aws_subnet.privada2.id
    route_table_id = aws_route_table.privada.id
}

#grupos de seguridad
resource "aws_security_group" "ssh" {
    name = "SSH"
    description = "Permisos de SSH al trafico"
    vpc_id = aws_vpc.esta.id
    ingress {
        description = "Permisos SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow HTTP"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags {
        Name = "PermisosSSH"
    }
}