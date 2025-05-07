#!/bin/bash

# Obtener IP desde terraform output
IP=$(terraform output -raw wordpress_public_ip)

# Escribir el archivo de inventario
cat > ansible/inventory.ini <<EOF
[wordpress]
$IP ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/devops.pem
EOF

echo "✅ Inventory generado en ansible/inventory.ini con IP: $IP"
