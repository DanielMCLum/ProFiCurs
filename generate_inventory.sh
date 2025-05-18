#!/bin/bash

TF_STATE_DIR="terraform"
ANSIBLE_DIR="ansible"
INVENTORY_FILE="${ANSIBLE_DIR}/inventory.ini"
GROUP_VARS_FILE="${ANSIBLE_DIR}/group_vars/all.yml"

# Obtener IPs públicas desde Terraform
IP_LIST=$(terraform -chdir=${TF_STATE_DIR} output -json | jq -r '.ec2_public_ips.value[]')

# Obtener el ID del EFS desde Terraform
EFS_ID=$(terraform -chdir=${TF_STATE_DIR} output -raw efs_id)

# Crear/Actualizar archivo de inventario
echo "[web]" > "${INVENTORY_FILE}"
for ip in $IP_LIST; do
  echo "$ip ansible_user=ubuntu ansible_ssh_private_key_file=terraform/devops.pem" >> "${INVENTORY_FILE}"
done

# Añadir el ID del EFS a group_vars/all.yml
if grep -q "^efs_id:" "$GROUP_VARS_FILE"; then
  # Si ya existe, lo reemplaza
  sed -i "s/^efs_id:.*/efs_id: ${EFS_ID}/" "$GROUP_VARS_FILE"
else
  # Si no existe, lo añade
  echo -e "\nefs_id: ${EFS_ID}" >> "$GROUP_VARS_FILE"
fi

echo "✅ Inventario actualizado en: ${INVENTORY_FILE}"
echo "✅ EFS ID actualizado en: ${GROUP_VARS_FILE}"


