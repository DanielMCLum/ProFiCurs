# Variables
TF_DIR=terraform
ANSIBLE_DIR=ansible
KEY_PATH=$(TF_DIR)/devops.pem
INVENTORY=$(ANSIBLE_DIR)/inventory.ini

.PHONY: all apply destroy plan inventory ansible

## apply: Aplica Terraform, genera inventario y ejecuta Ansible
apply: terraform apply inventory ansible

## terraform: Ejecuta terraform init y apply
terraform:
	cd $(TF_DIR) && terraform init && terraform apply -auto-approve

## destroy: Destruye toda la infraestructura
destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve

## inventory: Genera archivo de inventario Ansible desde Terraform output
inventory:
	@echo "🔍 Generando archivo de inventario..."
	@IP=$$(cd $(TF_DIR) && terraform output -raw wordpress_public_ip); \
	echo "[wordpress]" > $(INVENTORY); \
	echo "$$IP ansible_user=ubuntu ansible_ssh_private_key_file=$(KEY_PATH)" >> $(INVENTORY); \
	echo "✅ Inventory generado con IP: $$IP"

## ansible: Ejecuta el playbook de Ansible
ansible:
	ansible-playbook -i $(INVENTORY) $(ANSIBLE_DIR)/playbook.yml

## plan: Muestra un plan de Terraform
plan:
	cd $(TF_DIR) && terraform plan
