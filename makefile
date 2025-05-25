# Variables
TF_DIR=terraform
ANSIBLE_DIR=ansible
GROUP_VARS_FILE=$(ANSIBLE_DIR)/group_vars/all.yml

.PHONY: all init apply destroy ansible inventory output plan validate deploy help

# Ejecuta todo el flujo: init, apply, inventario, ansible
all: init apply inventory ansible output

# Inicializa Terraform
init:
	terraform -chdir=$(TF_DIR) init

# Aplica la infraestructura con Terraform
apply:
	terraform -chdir=$(TF_DIR) apply -auto-approve

# Valida sintaxis y lógica del código Terraform
validate:
	terraform -chdir=$(TF_DIR) validate

# Muestra el plan de cambios de Terraform
plan:
	terraform -chdir=$(TF_DIR) plan

# Ejecuta destroy de toda la infraestructura
destroy:
	terraform -chdir=$(TF_DIR) destroy -auto-approve

# Solo actualiza el efs_id en group_vars/all.yml
inventory:
	@echo "Actualizando configuración de EFS para Ansible..."
	@./generate_inventory.sh

# Ejecuta Ansible usando inventario dinámico (aws_ec2.yaml definido en ansible.cfg)
# Y usando el entorno virtual
ansible:
	. .venv/bin/activate && \
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i $(ANSIBLE_DIR)/aws_ec2.yaml $(ANSIBLE_DIR)/playbook.yml


# Alternativa sin reinicializar
deploy:
	$(MAKE) apply
	$(MAKE) inventory
	$(MAKE) ansible
	$(MAKE) output

# Muestra las salidas definidas en outputs.tf
output:
	terraform -chdir=$(TF_DIR) output

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo ""
	@echo "  make init       - Inicializa Terraform en el directorio ./terraform"
	@echo "  make apply      - Aplica la infraestructura con Terraform"
	@echo "  make inventory  - Actualiza efs_id en group_vars/all.yml"
	@echo "  make ansible    - Ejecuta Ansible con inventario dinámico"
	@echo "  make deploy     - Ejecuta apply, inventory y ansible (sin init)"
	@echo "  make destroy    - Elimina toda la infraestructura provisionada"
	@echo "  make all        - Ejecuta init, apply, inventory y ansible, en ese orden"
	@echo "  make output     - Muestra los valores de salida de Terraform"
	@echo "  make help       - Muestra esta ayuda"
