#!/bin/bash

TF_STATE_DIR="terraform"
ANSIBLE_DIR="ansible"
INVENTORY_FILE="${ANSIBLE_DIR}/inventory.ini"
GROUP_VARS_FILE="${ANSIBLE_DIR}/group_vars/all.yml"

# Obtener el ID del EFS desde Terraform
EFS_ID=$(terraform -chdir=${TF_STATE_DIR} output -raw efs_id)

# Actualizar efs_id en group_vars/all.yml
if grep -q "^efs_id:" "$GROUP_VARS_FILE"; then
  sed -i "s/^efs_id:.*/efs_id: ${EFS_ID}/" "$GROUP_VARS_FILE"
else
  echo -e "\nefs_id: ${EFS_ID}" >> "$GROUP_VARS_FILE"
fi

# Obtener IPs públicas de instancias con el tag Name=wordpress-asg
echo "[web]" > "$INVENTORY_FILE"
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=wordpress-asg" "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].PublicIpAddress' \
  --output text |
while read ip; do
  echo "$ip ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/devops.pem" >> "$INVENTORY_FILE"
done

echo "✅ Inventario actualizado en: ${INVENTORY_FILE}"
echo "✅ EFS ID actualizado en: ${GROUP_VARS_FILE}"



