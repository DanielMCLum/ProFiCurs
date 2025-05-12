# 🚀 Configuración de WordPress en Azure (para estudiantes)

Este proyecto despliega una instancia de **WordPress** en **Azure** utilizando **Terraform**, con un enfoque en costos reducidos para estudiantes.

## 📌 Requisitos previos

Antes de ejecutar este código, asegúrate de tener:

- Una cuenta de **Azure** con permisos suficientes.
- **Terraform** instalado en tu sistema.
- Variables definidas en un archivo `terraform.tfvars` (especialmente `mysql_admin_password`).
- Un archivo `.gitignore` para evitar subir credenciales sensibles.

## 📂 Estructura del proyecto

El código Terraform se organiza en los siguientes archivos:

📂 wordpress-azure ├── main.tf # Infraestructura principal ├── provider.tf # Configuración del proveedor de Azure ├── variables.tf # Definición de variables ├── terraform.tfvars # Valores sensibles (NO subir a GitHub) ├── outputs.tf # Variables de salida ├── .gitignore # Archivos a excluir del repositorio ├── README.md # Documentación

## 🏗️ Recursos implementados

### 1️⃣ `main.tf` - Infraestructura principal
Define los recursos esenciales:
- **Grupo de recursos** (`azurerm_resource_group`)
- **App Service Plan** (`azurerm_service_plan`)
- **Aplicación Web WordPress** (`azurerm_linux_web_app`)
- **Base de datos MySQL** (`azurerm_mysql_flexible_server`)
- **Reglas de firewall** (`azurerm_mysql_flexible_server_firewall_rule`)

### 2️⃣ `provider.tf` - Configuración del proveedor
Define el proveedor de **Azure** en Terraform. Se recomienda usar **variables** en lugar de credenciales expuestas.

### 3️⃣ `variables.tf` - Variables de configuración
Define variables como:
- **Región de despliegue** (`location`)
- **Credenciales de Azure** (`subscription_id`, `client_id`, `client_secret`, `tenant_id`)
- **Contraseña de MySQL** (`mysql_admin_password`)

### 4️⃣ `terraform.tfvars` - Valores sensibles
Este archivo contiene valores **privados** y **NO debe subirse a GitHub**. Se recomienda agregarlo a `.gitignore`.

### 5️⃣ `outputs.tf` - Variables de salida
Después del despliegue, Terraform mostrará la siguiente información:
- **URL de WordPress** (`wordpress_url`)

## 🚀 Despliegue

Para desplegar la infraestructura:

```sh
terraform init
terraform plan
terraform apply -auto-approve
