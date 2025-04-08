resource "aws_security_group" "minio-sg" {
    name_prefix = "SGminio"
    vpc_id      = "aws_vpc.vpc.id"
    ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso a la API de Minio"
    }

    ingress {
        from_port   = 9001
        to_port     = 9001
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso a la consola de Minio"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SG-Minio"
    }
}