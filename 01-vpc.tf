#VPC (definimos la red)
resource "aws_vpc" "vpc" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "VPC"
    }
}

#Subnets publicas
resource "aws_subnet" "public1" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.10.1.0/24"
    availability_zone   = "us-east-1a"
    tags = {
        Name = "subnetPub1"
    }
}

resource "aws_subnet" "public2" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.10.2.0/24"
    availability_zone   = "us-east-1b"
    tags = {
        Name = "subnetPub2"
    }
}

#Subnets privada
resource "aws_subnet" "private1" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.10.3.0/24"
    availability_zone   = "us-east-1a"
    tags = {
        Name = "subnetPri1"
    }
}

resource "aws_subnet" "private2" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.10.4.0/24"
    availability_zone   = "us-east-1b"
    tags = {
        Name = "subnetPri2"
    }
}