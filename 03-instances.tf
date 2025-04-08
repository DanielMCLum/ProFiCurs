# Define una configuración de inicio para las instancias EC2 de Minio
resource "aws_launch_template" "minio_lt" {
    name_prefix   = "minio-lt-"
    image_id      = "ami-0f9de6e2d2f067fca"
    vpc_security_group_ids = [aws_security_group.minio_sg.id]

    tags = {
        Name = "templade-minio"
    }
}

# Define un Auto Scaling Group para las instancias de Minio
resource "aws_autoscaling_group" "minio_asg" {
    name_prefix        = "minio-asg-"
    launch_template {
        id      = aws_launch_template.minio_lt.id
        version = "$Latest"
    }
    vpc_zone_identifier = ["aws_subnet.public1.id", "aws_subnet.public1.id"]
    desired_capacity   = 2
    min_size           = 2
    max_size           = 4
    health_check_type = "EC2"

    tags = [
        {
        key                 = "Name"
        value               = "minio-instance"
        propagate_at_launch = true
        },
    ]
}