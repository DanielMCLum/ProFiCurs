# Infraestructura CMS Wordpress en AWS con Terraform y Ansible

Este proyecto despliega una infraestructura completa y escalable para WordPress en AWS usando **Terraform** como herramienta de aprovisionamiento y **Ansible** para la configuración. Incluye balanceo de carga, autoescalado, almacenamiento compartido (EFS), base de datos en Amazon RDS y monitoreo con alertas.

---

## Tecnologías utilizadas

- **Terraform** (Infraestructura como Código)
- **Ansible** (Automatización de configuración)
- **Amazon Web Services**:
  - EC2, ALB, Auto Scaling Group
  - EFS (almacenamiento compartido)
  - RDS (MySQL)
  - VPC personalizada
  - CloudWatch + SNS (monitoreo y alertas)

---

## 📁 Estructura del proyecto

```plaintext
proyecto/
├── terraform/              # Código de infraestructura (VPC, EC2, ALB, EFS, RDS, ASG)
├── ansible/                # Roles de configuración (nginx, php, mysql, wordpress)
│   ├── group_vars/         # Variables globales de Ansible
│   ├── roles/              # Roles Ansible separados por componente
│   └── aws_ec2.yaml        # Inventario dinámico basado en etiquetas EC2
├── generate_inventory.sh   # Script que actualiza variables desde Terraform
├── Makefile                # Automatiza terraform + ansible
├── ansible.cfg             # Configuración general de Ansible
└── README.md               # Documentación del proyecto (este archivo)
```

---

## ⚙️ ¿Qué se despliega?

| Componente        | Descripción |
|-------------------|-------------|
| VPC personalizada | Subredes públicas, tabla de rutas, IGW |
| EC2               | Instancias en Auto Scaling Group para WordPress |
| ALB               | Application Load Balancer con HTTPS y redirección desde HTTP |
| EFS               | Almacenamiento compartido entre instancias (persistencia de datos) |
| RDS (MySQL)       | Base de datos administrada por Amazon |
| Ansible           | Instalación de WordPress, Nginx, PHP, configuración dinámica |
| CloudWatch + SNS  | Alertas por CPU y tráfico de red, enviadas por email |

---

## 🛠️ Requisitos

- Cuenta de AWS (con permisos para EC2, VPC, RDS, ALB, CloudWatch, SNS...)
- Instalación `terraform >= 1.3`
- Instalación `ansible >= 2.12`
- Acceso SSH para conectarse a las instancias (clave generada automáticamente)
- Python y entorno virtual para Ansible + boto3

---

## 🧪 Despliegue rápido

```bash
# Clona el repositorio y entra
git clone https://github.com/DanielMCLum/ProFiCurs.git
cd proyecto-wordpress-aws

# Crea el entorno virtual
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Lanza toda la infraestructura + ansible + configuración
make all


Cuando finalice, abre el navegador en:
https://www.dominio.com (definido en group_vars/all.yml)

```

---

## 📉 Escalabilidad automática
Se incluyen alarmas y políticas:

* Aumenta instancias si CPU > 90%

* Reduce si CPU < 20%

* Persistencia de archivos gracias a EFS

Todo configurado por Terraform y verificado con CloudWatch



## 📬 Alertas por email
Recibirás correos si:

* La CPU sube o baja demasiado

* Hay tráfico de red anómalo (entrante o saliente)

Todo configurable en `10-monitoring.tf`



## Estado actual
* Infraestructura reproducible

* Instalación automática de WordPress

* Auto scaling funcional

* Persistencia de datos activa

* Monitoreo y alertas por email

* Documentación paso a paso




## Licencia y condiciones de uso

Este proyecto ha sido desarrollado como parte del módulo de Proyecto Final del ciclo formativo de grado superior en **Administración de Sistemas Informáticos en Red (ASIR)**.

### Uso permitido
Puedes consultar libremente el código, estructura y configuraciones de este repositorio con fines **educativos o de aprendizaje personal**.

### Reutilización del código
Si deseas reutilizar parte del código, adaptar este proyecto para otro entorno o incluirlo en tu propio trabajo.

Esto ayuda a preservar la originalidad de los proyectos académicos y a fomentar un uso ético del conocimiento compartido.

---

### Aviso legal

El contenido de este repositorio está protegido por derechos de autor.  
Cualquier uso no autorizado para comercialización será considerado una infracción.
 
**Curso**: Proyecto Final ASIX · 2025 · INS PROVENÇANA

Copyright (c) 2025 

