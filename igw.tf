#igw
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "igw"
    }
}

#elastic ip
resource "aws_eip" "eip" {
    domain = "vpc"
}

#nat gateway
resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.eip.id
    subnet_id       = aws_subnet.public1.id
    tags = {
        Name = "Nat"
    }
}

#tabla de enrutamiento publica
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "rtPublica"
    }
}

#tabla de enrutamiento privada
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "rtPrivada"
    }
}