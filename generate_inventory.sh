#!/bin/bash

TF_STATE_DIR="terraform"
INVENTORY_FILE="ansible/inventory.ini"

# Obtener IPs públicas de instancias EC2 desde Terraform
IP_LIST=$(terraform -chdir="$TF_STATE_DIR" output -json | jq -r '.ec2_public_ips.value[]')

# Escribir encabezado de grupo
echo "[web]" > "$INVENTORY_FILE"

# Escribir cada IP en el archivo inventory.ini
for ip in $IP_LIST; do
  echo "$ip ansible_user=ubuntu ansible_ssh_private_key_file=terraform/devops.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> "$INVENTORY_FILE"
done

echo "✅ Inventario Ansible actualizado en: $INVENTORY_FILE"

