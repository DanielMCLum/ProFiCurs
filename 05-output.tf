output "moodle_instance_public_ip" {
    value       = aws_instance.moodle.public_ip
    description = "La IP pública de la instancia EC2 de Moodle"
}

output "rds_endpoint" {
    value       = aws_db_instance.moodledb.endpoint
    description = "El endpoint de la instancia RDS de Moodle"
}

/*resource "null_resource" "output_to_json" {
    depends_on = [
        aws_db_instance.moodledb,
    ]
    provisioner "local-exec" {
        command = "bash terraform_output.sh"
    }
}*/