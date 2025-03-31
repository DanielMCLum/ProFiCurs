#EC2
resource "aws_instance" "wordpress" {
  ami               = "ami-071226ecf16aa7d96"
  instance_type     = "t2.micro"
  key_name          = "wordpress"
  subnet_id         = aws_subnet.publica1.id
  security_groups   = [aws_security_group.ssh.id]
  associate_public_ip_address = true
  tags = {
    Name = "wordpress"
  }
}

#subnet para DB
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "grupo_subnet_rds"
    subnet_ids = [aws_subnet.privada1.id, aws_subnet.privada2.id]
}

#Intancia DB (RDS)
resource "aws_db_instance" "intanciaBD" {
    engine  = "mysql"
    engine_version  = "5.7"
    skip_final_snapshot     = true
    final_snapshot_identifier = "snapshot_final"
    instance_class          = "db.t2.micro"
    allocated_storage       = 20
    identifier              = "intancia_db"
    db_name                 = "wordpress_db"
    username                = "ansibleops"
    password                = "ansibleops123$"
    db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids  = [aws_security_group.grupoSeguridadDB.id]
    tags                    = {
        Name = "RDS Intance"
    } 
}
# Grupo de seguridad
resource "aws_security_group" "grupoSeguridadDB" {
    name        = "GrupoSeguridadDB"
    description = "Grupo de seguridad para la instancia DB"
    vpc_id      = aws_vpc.esta.id
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.100.0.0/16"]
    }

    tags = {
        Name = "Grupo de seguridad DB"
    }
}