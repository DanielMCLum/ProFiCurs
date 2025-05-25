# ========================================
# VPC personalizada para la infraestructura
# ========================================
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"     # Rango de red IP privado para toda la VPC
  enable_dns_hostnames = true              # Habilita los nombres DNS internos para instancias EC2
  enable_dns_support   = true              # Permite que la VPC resuelva DNS

  tags = {
    Name = "wordpress-vpc"                 # Nombre descriptivo en AWS
  }
}

# ========================================
# Subred pública A (en zona de disponibilidad us-east-1a)
# ========================================
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.1.0/24"        # Rango de IPs de esta subred
  availability_zone = "us-east-1a"          # AZ específica para distribución geográfica

  tags = {
    Name = "wordpress-public-a"
  }
}

# ========================================
# Subred pública B (en zona de disponibilidad us-east-1b)
# ========================================
resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "wordpress-public-b"
  }
}

# ========================================
# Internet Gateway: permite salida a Internet
# ========================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wordpress-igw"
  }
}

# ========================================
# Tabla de rutas públicas
# ========================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"               # Todo el tráfico externo
    gateway_id = aws_internet_gateway.igw.id  # Lo dirige al Internet Gateway
  }

  tags = {
    Name = "wordpress-public-rt"
  }
}

# ========================================
# Asociación de subred A con la tabla de rutas públicas
# ========================================
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ========================================
# Asociación de subred B con la tabla de rutas públicas
# ========================================
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}