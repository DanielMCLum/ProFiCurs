# Accede a la VPC por defecto de AWS
data "aws_vpc" "default" {
  default = true
}

# Obtiene todas las subredes por defecto asociadas a la VPC (una por zona de disponibilidad)
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}
