# IGW
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "igw"
    }
}

# Elastic ip para la NAT Gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

# Nat gateway
resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.nat_eip.id
    subnet_id       = aws_subnet.public1.id
    depends_on = [aws_eip.nat_eip]
    tags = {
        Name = "Nat"
    }
}

# Tabla de enrutamiento publica
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

# Tabla de enrutamiento privada
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