#vpc (definimos la red)
resource "aws_vpc" "esta" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "VPC"
    }
}

#subnets publicas
resource "aws_subnet" "publica1" {
    vpc_id      = aws_vpc.esta.id
    cidr_block  = "10.10.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "subnetPublica1"
    }
}

resource "aws_subnet" "publica2" {
    vpc_id      = aws_vpc.esta.id
    cidr_block  = "10.10.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "subnetPublica2"
    }
}

#subnets privada
resource "aws_subnet" "privada1" {
    vpc_id      = aws_vpc.esta.id
    cidr_block  = "10.10.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "subnetPrivada1"
    }
}

resource "aws_subnet" "privada2" {
    vpc_id      = aws_vpc.esta.id
    cidr_block  = "10.10.4.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "subnetPrivada2"
    }
}