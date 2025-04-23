# VPC (definimos la red)
resource "aws_vpc" "vpc_moodle" {
    cidr_block = "10.20.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "moodle-VPC"
    }
}

# Subnets publicas
resource "aws_subnet" "public1_moodle" {
    vpc_id              = aws_vpc.vpc_moodle.id
    cidr_block          = "10.20.1.0/24"
    availability_zone   = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "subnetPub1_moodle"
    }
}

resource "aws_subnet" "public2_moodle" {
    vpc_id              = aws_vpc.vpc_moodle.id
    cidr_block          = "10.20.2.0/24"
    availability_zone   = "us-east-1b"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "subnetPub2_moodle"
    }
}

# Subnets privadas
resource "aws_subnet" "private1_moodle" {
    vpc_id              = aws_vpc.vpc_moodle.id
    cidr_block          = "10.20.3.0/24"
    availability_zone   = "us-east-1a"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "subnetPri1_moodle"
    }
}

resource "aws_subnet" "private2_moodle" {
    vpc_id              = aws_vpc.vpc_moodle.id
    cidr_block          = "10.20.4.0/24"
    availability_zone   = "us-east-1b"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "subnetPri2_moodle"
    }
}
 
# Gateway
resource "aws_internet_gateway" "igw_moodle" {
    vpc_id = aws_vpc.vpc_moodle.id
    tags = {
        Name = "IGW_moodle"
    }
}

# Tabla de enrutamiento
resource "aws_route_table" "public_rt_moodle" {
    vpc_id = aws_vpc.vpc_moodle.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_moodle.id
    }
    tags = {
        Name = "RtPublica_moodle"
    }
}

resource "aws_route_table" "private_rt_moodle" {
    vpc_id = aws_vpc.vpc_moodle.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_moodle.id
    }
    tags = {
        Name = "RtPrivate_moodle"
    }
}

# Asociar las subredes a la tabla de enrutamiento
resource "aws_route_table_association" "rt_pub1asso_moodle" {
    subnet_id       = aws_subnet.public1_moodle.id
    route_table_id  = aws_route_table.public_rt_moodle.id
}

resource "aws_route_table_association" "rt_pub2asso_moodle" {
    subnet_id       = aws_subnet.public2_moodle.id
    route_table_id  = aws_route_table.public_rt_moodle.id
}

resource "aws_eip" "Nat1_moodle" {
    depends_on = [aws_route_table_association.rt_pub1asso_moodle, aws_route_table_association.rt_pub2asso_moodle]
    domain = "vpc"
}

resource "aws_nat_gateway" "Nat1_Gt_moodle" {
    depends_on = [aws_eip.Nat1_moodle]
    allocation_id = aws_eip.Nat1_moodle.id
    subnet_id = aws_subnet.public1_moodle.id
    tags = {
        Name = "Nat-Gateway1"
    }
}

resource "aws_route_table" "Nat1_Gt_rt_moodle" {
    depends_on = [aws_nat_gateway.Nat1_Gt_moodle]
    vpc_id = aws_vpc.vpc_moodle.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Nat1_Gt_moodle.id
    }
    tags = {
        Name = "Tabla de enrutamiento NAT 1"
    }
}

resource "aws_route_table_association" "rt_Nat1_Gt_asso_moodle" {
    depends_on = [aws_route_table.Nat1_Gt_rt_moodle]
    subnet_id      = aws_subnet.private1_moodle.id
    route_table_id = aws_route_table.Nat1_Gt_rt_moodle.id
}

resource "aws_eip" "Nat2_moodle" {
    depends_on = [aws_route_table_association.rt_pub1asso_moodle, aws_route_table_association.rt_pub2asso_moodle]
    domain = "vpc"
}

resource "aws_nat_gateway" "Nat2_Gt_moodle" {
    depends_on = [aws_eip.Nat2_moodle]
    allocation_id = aws_eip.Nat2_moodle.id
    subnet_id = aws_subnet.public2_moodle.id
    tags = {
        Name = "Nat-Gateway2"
    }
}

resource "aws_route_table" "Nat2_Gt_rt_moodle" {
    depends_on = [aws_nat_gateway.Nat2_Gt_moodle]
    vpc_id = aws_vpc.vpc_moodle.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Nat2_Gt_moodle.id
    }
    tags = {
        Name = "Tabla de enrutamiento NAT 2"
    }
}

resource "aws_route_table_association" "rt_Nat2_Gt_asso_moodle" {
    depends_on = [aws_route_table.Nat2_Gt_rt_moodle]
    subnet_id      = aws_subnet.private2_moodle.id
    route_table_id = aws_route_table.Nat2_Gt_rt_moodle.id
}