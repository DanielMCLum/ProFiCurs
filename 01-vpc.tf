# VPC (definimos la red)
resource "aws_vpc" "vpc" {
    cidr_block = "10.20.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "minio-VPC"
    }
}

# Subnets publicas
resource "aws_subnet" "public1" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.20.1.0/24"
    availability_zone   = "us-east-1a"
    tags = {
        Name = "subnetPub1"
    }
}

resource "aws_subnet" "public2" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.20.2.0/24"
    availability_zone   = "us-east-1b"
    tags = {
        Name = "subnetPub2"
    }
}
 
# Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Minio-IGW"
    }
}

# Tabla de enrutamiento
resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Minio-RtPublica"
    }
}

# Asociar las subredes a la tabla de enrutamiento
resource "aws_route_table_association" "public1" {
    subnet_id       = aws_subnet.public1.id
    route_table_id  = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public2" {
    subnet_id       = aws_subnet.public2.id
    route_table_id  = aws_route_table.public-rt.id
}