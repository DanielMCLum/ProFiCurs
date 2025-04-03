#!/bin/bash

# Obtener la IP pública de la instancia desde Terraform
PUBLIC_IP=$(terraform output -raw instance_public_ip)

# Nombre del usuario SSH (depende de la AMI usada)
SSH_USER="ubuntu"

# Ruta a la clave privada SSH
PRIVATE_KEY_PATH="~/.ssh/vockey.pem"

# Crear el archivo de inventario de Ansible
echo "[wordpress]" > ../ansible/inventory
echo "$PUBLIC_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$PRIVATE_KEY_PATH" >> ../ansible/inventory

echo "Archivo de inventario generado en ansible/inventory"