resource "aws_rds_cluster" "moodledb-cluster" {
  cluster_identifier   = "moodle-cluster"
  engine               = mysql
  engine_version       = "8.0"
  database_name        = "moodle_db"
  master_username      = "admin"
  master_password      = "Pirineus123$" 
  backup_retention_period = var.backup_retention_period 
  preferred_backup_window = var.preferred_backup_window 
  preferred_maintenance_window = var.preferred_maintenance_window
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.RDS_allow_rule.id]
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_grp.id
}