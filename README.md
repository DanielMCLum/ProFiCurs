# ProFiCursb
# Terraform: Despliegue de Infraestructura AWS para WordPress y Ansible  

Este repositorio contiene código Terraform para desplegar una infraestructura básica en AWS que incluye:  
- **1 instancia EC2 para Ansible** (con Ansible preinstalado)  
- **1 instancia EC2 para WordPress**  
- **1 Security Group** que permite tráfico SSH (22) y HTTP (80)  

---

## 🌐 **Recursos Creados**  

### 1. **Security Group (`wordpress_sg`)**  
- **Reglas de Entrada (ingress):**  
  - **SSH (22):** Acceso desde cualquier IP (`0.0.0.0/0`).  
  - **HTTP (80):** Acceso público para WordPress.  
- **Reglas de Salida (egress):**  
  - Permite todo el tráfico saliente.  

### 2. **Instancia EC2 para Ansible (`ansible_host`)**  
- **AMI:** `ami-0c02fb55956c7d316` (Amazon Linux 2).  
- **Tipo:** `t2.micro` (gratis en capa free tier).  
- **Script de User Data:** Instala Ansible automáticamente al iniciar.  
- **Key Pair:** `AWS-Samuel` (debes tener esta clave en AWS).  

### 3. **Instancia EC2 para WordPress (`wordpress_host`)**  
- Misma configuración que `ansible_host` pero sin Ansible preinstalado.  
- Ideal para luego configurar WordPress manualmente o con Ansible.  

### 4. **Outputs**  
- Muestra las IPs públicas de ambas instancias al finalizar el despliegue:  
  ```terraform
  ansible_public_ip = "X.X.X.X"
  wordpress_public_ip = "Y.Y.Y.Y"
  ```

---

## 🚀 **Cómo Usar**  

### **Requisitos Previos**  
1. **Terraform instalado** ([Guía de instalación](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).  
2. **AWS CLI configurado** con credenciales válidas (`aws configure`).  
3. **Key Pair `AWS-Samuel`** creada en AWS (o modifica `key_name` en el código).  

### **Pasos para Desplegar**  
1. Clona este repositorio:  
   ```bash
   git clone https://github.com/tu-usuario/tu-repo.git
   cd tu-repo
   ```
2. Inicializa Terraform:  
   ```bash
   terraform init
   ```
3. Revisa el plan de ejecución:  
   ```bash
   terraform plan
   ```
4. Aplica los cambios (crea la infraestructura):  
   ```bash
   terraform apply
   ```
5. **¡Listo!** Las IPs públicas se mostrarán al final.  

---

## 🔧 **Variables Personalizables**  
- **`region`**: Por defecto es `us-east-1`. Modifícala en `variables.tf` si necesitas otra región.  
- **`instance_type`**: Cambia a `t2.small` si necesitas más recursos.  
- **`ami`**: Actualiza el ID de la AMI según la región o versión de SO.  

---

## 🛠 **Próximos Pasos**  
1. **Configurar WordPress**: Usa Ansible para automatizar la instalación de WordPress en `wordpress_host`.  
2. **Agregar RDS**: Añade una base de datos MySQL/Aurora con Terraform.  
3. **Habilitar HTTPS**: Modifica el Security Group para permitir el puerto 443 y usa Certbot.  

---

## 📜 **Licencia**  
Este proyecto está bajo licencia MIT.  

--- 


