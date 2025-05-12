# 🚀 Configuración de WordPress en Azure (para estudiantes)

Este proyecto despliega una instancia de WordPress en **Azure** utilizando **Terraform**, con un enfoque en costos reducidos para estudiantes.

## 📌 Requisitos previos

Antes de ejecutar este código, asegúrate de tener:

- Una cuenta de **Azure** con permisos suficientes.
- **Terraform** instalado en tu sistema.
- Variables definidas en un archivo `terraform.tfvars` (especialmente `mysql_admin_password`).

## 📂 Recursos implementados

### 1️⃣ Grupo de recursos
Define el grupo de recursos donde se alojarán todos los servicios.

### 2️⃣ App Service Plan (Gratis)
Se usa el plan **F1** gratuito, con límites de CPU.

### 3️⃣ Aplicación Web (WordPress)
Se despliega la aplicación web con **PHP 8.2** y configuración optimizada.

### 4️⃣ Base de datos MySQL
Se usa **Azure Flexible Server** con una SKU económica.

### 5️⃣ Base de datos WordPress
Se crea la base de datos con configuración UTF-8.

### 6️⃣ Sufijo aleatorio
Se genera un sufijo aleatorio para nombres únicos.

### 7️⃣ Reglas de firewall
Se permite el acceso desde servicios de Azure.

## 🚀 Despliegue

Para desplegar la infraestructura:

```sh
terraform init
terraform plan
terraform apply -auto-approve
