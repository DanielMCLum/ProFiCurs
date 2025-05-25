resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "WordPress DB Subnet Group"
  }
}

resource "aws_db_instance" "wordpress" {
  identifier        = "wordpress-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro" # Gratis con AWS Free Tier
  allocated_storage = 20
  storage_type      = "gp2"

  db_name           = var.wp_db_name
  username          = var.wp_db_user
  password          = var.wp_db_password
  port              = 3306

  publicly_accessible = false
  multi_az            = false

  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  skip_final_snapshot    = true

  tags = {
    Name = "WordPress-RDS"
  }
}
