# ============================================
# Backup Automático para EFS (No habilitado)
# ============================================

# Comentado porque las cuentas con permisos limitados (como AWS Educate o voclabs)
# no permiten crear roles IAM necesarios para ejecutar AWS Backup desde Terraform.
# Cuando se tenga una cuenta personal con permisos completos, se podrá descomentar.

# resource "aws_backup_vault" "wordpress_vault" {
#   name        = "wordpress-backup-vault"
#   tags = {
#     Name = "WordPress Backup Vault"
#   }
# }

# resource "aws_backup_plan" "wordpress_backup" {
#   name = "wordpress-backup-plan"

#   rule {
#     rule_name         = "daily-backup"
#     target_vault_name = aws_backup_vault.wordpress_vault.name
#     schedule          = "cron(0 5 * * ? *)" # Diariamente a las 5:00 UTC
#     lifecycle {
#       delete_after = 14 # Días
#     }
#   }

#   tags = {
#     Name = "WordPress Daily Backup Plan"
#   }
# }

# resource "aws_iam_role" "backup_role" {
#   name = "aws-backup-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "backup.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "backup_role_policy" {
#   role       = aws_iam_role.backup_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
# }

# resource "aws_backup_selection" "efs_selection" {
#   name          = "efs-backup-selection"
#   iam_role_arn  = aws_iam_role.backup_role.arn
#   plan_id       = aws_backup_plan.wordpress_backup.id

#   resources = [
#     aws_efs_file_system.wordpress.arn
#   ]
# }





