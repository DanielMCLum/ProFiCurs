# Variables
TF_DIR=terraform
ANSIBLE_DIR=ansible

KEY_PATH=$(TF_DIR)/devops.pem
INVENTORY_FILE=$(ANSIBLE_DIR)/inventory.ini

.PHONY: all init apply destroy ansible inventory output plan validate deploy help

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

# Genera el inventario dinámico desde Terraform y AWS para Ansible
inventory:
	@echo "Actualizando inventario Ansible..."
	@./generate_inventory.sh

# Ejecuta Ansible sobre las instancias creadas
ansible:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i $(INVENTORY_FILE) $(ANSIBLE_DIR)/playbook.yml

# Alternativa sin reinicializar
deploy: ## Ejecuta apply + inventory + ansible (sin init)
	$(MAKE) apply
	$(MAKE) inventory
	$(MAKE) ansible

# Muestra las salidas definidas en outputs.tf
output:
	terraform -chdir=$(TF_DIR) output

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo ""
	@echo "  make init       - Inicializa Terraform en el directorio ./terraform"
	@echo "  make apply      - Aplica la infraestructura con Terraform"
	@echo "  make inventory  - Genera el inventario dinámico para Ansible"
	@echo "  make ansible    - Ejecuta Ansible usando el inventario generado"
	@echo "  make deploy     - Ejecuta apply, inventory y ansible (sin init)"
	@echo "  make destroy    - Elimina toda la infraestructura provisionada"
	@echo "  make all        - Ejecuta init, apply, inventory y ansible, en ese orden"
	@echo "  make output     - Muestra los valores de salida de Terraform"
	@echo "  make help       - Muestra esta ayuda"
