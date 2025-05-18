# Variables
TF_DIR=terraform
ANSIBLE_DIR=ansible

KEY_PATH=$(TF_DIR)/devops.pem

# Variables dinámicas
INVENTORY_FILE=$(ANSIBLE_DIR)/inventory.ini

.PHONY: all init apply destroy ansible inventory output plan validate

# Ejecuta todo el flujo: init, apply, inventario, ansible
all: init apply inventory ansible

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

# Genera el inventario dinámico desde Terraform para Ansible
inventory:
	@echo "Actualizando inventario Ansible..."
	@./generate_inventory.sh

# Ejecuta Ansible sobre las instancias creadas
ansible:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i $(INVENTORY_FILE) $(ANSIBLE_DIR)/playbook.yml

deploy: ## Ejecuta apply + inventory + ansible (sin init)
	$(MAKE) apply
	$(MAKE) inventory
	$(MAKE) ansible
	

# Muestra las salidas definidas en outputs.tf
output:
	terraform -chdir=$(TF_DIR) output


help:
	@echo "Comandos disponibles:"
	@echo ""
	@echo "  make init       - Inicializa Terraform en el directorio ./terraform"
	@echo "  make apply      - Aplica la infraestructura con Terraform"
	@echo "  make inventory  - Genera el inventario dinámico para Ansible"
	@echo "  make ansible    - Ejecuta Ansible usando el inventario generado"
	@echo "  make deploy	 - Ejecuta apply, inventory y ansible"
	@echo "  make destroy    - Elimina toda la infraestructura provisionada"
	@echo "  make all        - Ejecuta init, apply, inventory y ansible, en ese orden"
	@echo "  make help       - Muestra esta ayuda"
