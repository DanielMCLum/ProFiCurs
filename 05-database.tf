resource "aws_db_instance" "moodledb" {
    engine                      = "mysql"
    engine_version              = "8.0"
    skip_final_snapshot         = true
    multi_az                    = true
    final_snapshot_identifier   = "my-final-snapshot"
    instance_class              = "db.t3.micro"
    allocated_storage           = 20
    identifier                  = "rds-instance"
    db_name                     = "moodle_db"
    username                    = "admin"
    password                    = "Pirineus123$"
    vpc_security_group_ids = [aws_security_group.sg_rds_moodle.id]
    db_subnet_group_name   = aws_db_subnet_group.grp_rds_moodle.id
    tags = {
        Name = "RDS-intance"
    } 
}

/*resource "aws_rds_cluster" "moodledb-cluster" {
    cluster_identifier   = "moodle-cluster"
    engine               = "mysql"
    engine_version       = "8.0"
    database_name        = "moodle_db"
    master_username      = "admin"
    master_password      = "Pirineus123$"
    backup_retention_period = "5" // En dias
    preferred_backup_window = "01:00-01:30"
    preferred_maintenance_window = "Fri:23:00-Sat:04:00"
    skip_final_snapshot  = true
    vpc_security_group_ids = [aws_security_group.sg_rds_moodle.id]
    db_subnet_group_name   = aws_db_subnet_group.grp_rds_moodle.id
}

resource "aws_rds_cluster_instance" "moodledb1" {
    depends_on = [aws_rds_cluster.moodledb-cluster]
    identifier = "master"
    cluster_identifier    = aws_rds_cluster.moodledb-cluster.id
    instance_class        = "t3.micro"
    engine                = "mysql"
    publicly_accessible   = false
    db_subnet_group_name  = aws_db_subnet_group.grp_rds_moodle.name
}

resource "aws_rds_cluster_instance" "moodledb2" {
    depends_on = [aws_rds_cluster_instance.moodledb1]
    identifier = "slave"
    cluster_identifier    = aws_rds_cluster.moodledb-cluster.id
    instance_class        = "t3.micro"
    engine                = "mysql"
    publicly_accessible   = false
    db_subnet_group_name  = aws_db_subnet_group.grp_rds_moodle.name
}*/