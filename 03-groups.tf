# Tabla de enrutamiento
resource "aws_route_table_association" "public1" {
    subnet_id       = aws_subnet.public1.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id       = aws_subnet.public2.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
    subnet_id       = aws_subnet.private1.id
    route_table_id  = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
    subnet_id       = aws_subnet.private2.id
    route_table_id  = aws_route_table.private.id
}

# Grupos de seguridad para wordpress
resource "aws_security_group" "sg_wordpress" {
    name        = "SG-Wordpress"
    description = "Permisos a Wordpress"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        description = "Permisos SSH"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Permisos HTTP"
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
    tags = {
        Name = "Grupo de seguridad WP"
    }
}

# Grupo de seguridad para DB
resource "aws_security_group" "grupoSeguridadDB" {
    name        = "grupo_seguridad_db"
    description = "Grupo de seguridad para la instancia DB"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.sg_wordpress.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Grupo de seguridad DB"
    }
}

# Grupo subnet para DB
resource "aws_db_subnet_group" "rds_subnet_group" {
    name        = "grupo_subnet_rds"
    subnet_ids  = [aws_subnet.private1.id, aws_subnet.private2.id]
}