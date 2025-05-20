#!/bin/bash

TF_STATE_DIR="terraform"
ANSIBLE_DIR="ansible"
GROUP_VARS_FILE="${ANSIBLE_DIR}/group_vars/all.yml"

# Obtener el ID del EFS desde Terraform
EFS_ID=$(terraform -chdir=${TF_STATE_DIR} output -raw efs_id)

# Actualizar efs_id en group_vars/all.yml
if grep -q "^efs_id:" "$GROUP_VARS_FILE"; then
  sed -i "s/^efs_id:.*/efs_id: ${EFS_ID}/" "$GROUP_VARS_FILE"
else
  echo -e "\nefs_id: ${EFS_ID}" >> "$GROUP_VARS_FILE"
fi

echo "✅ EFS ID actualizado en: ${GROUP_VARS_FILE}"




