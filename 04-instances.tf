# EC2
resource "aws_instance" "wordpress" {
    ami                         = "ami-071226ecf16aa7d96"
    instance_type               = "t2.micro"
    key_name                    = "Vokey"
    subnet_id                   = aws_subnet.public1.id
    iam_instance_profile        = "LabInstanceProfile" 
    security_groups             = [aws_security_group.sg_wordpress.id]
    associate_public_ip_address = true
    tags = {
        Name = "wordpress-instance"
    }
}

# Intancia DB (RDS)
resource "aws_db_instance" "intanciaBD" {
    engine                      = "mysql"
    engine_version              = "8.0"
    skip_final_snapshot         = true
    final_snapshot_identifier   = "my-final-snapshot"
    instance_class              = "db.t3.micro"
    allocated_storage           = 20
    identifier                  = "my-rds-instance"
    db_name                     = "wordpress_db"
    username                    = "ansibleops"
    password                    = "ansibleops123$"
    db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids      = [aws_security_group.grupoSeguridadDB.id]
    tags = {
        Name = "RDS Intance"
    } 
}