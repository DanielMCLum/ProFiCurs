# Proyecto: Azure WordPress Infrastructure

Este proyecto utiliza Terraform para desplegar y gestionar una infraestructura en Azure que soporta una aplicación WordPress. La infraestructura incluye módulos para red, cómputo, base de datos y seguridad.

Arquitectura del Proyecto**

La infraestructura está dividida en módulos para facilitar la reutilización y administración:

✅ **Red (`network`)** → Configura la **VNet y subredes** necesarias para la comunicación entre los recursos.  
✅ **Cómputo (`compute`)** → Implementa un **VM Scale Set (VMSS)** para alojar múltiples instancias de máquinas virtuales.  
✅ **Base de Datos (`database`)** → Configura un **servidor MySQL** para almacenar información de la aplicación.  
✅ **Seguridad (`security`)** → Establece reglas de seguridad y monitoreo mediante **NSG y Azure Monitor**.  

## Contenido del Proyecto

### Archivos Principales
1. **[backend.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/backend.tf)**: Configuración del backend de Terraform utilizando Azure Storage para guardar el estado.
2. **[main.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/main.tf)**: Configuración principal que incluye los módulos de red, cómputo, base de datos y seguridad.
3. **[outputs.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/outputs.tf)**: Outputs para exponer identificadores clave como el de la VNet, VM Scale Set y otros recursos.
4. **[providers.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/providers.tf)**: Configuración del proveedor de Azure para la gestión de recursos.
5. **[terraform.tfvars](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/terraform.tfvars)**: Valores personalizados para variables del proyecto.
6. **[variables.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/variables.tf)**: Declaración de variables utilizadas en el proyecto.

### Estructura de Módulos

#### Módulo: Compute
- **[main.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/compute/main.tf)**: Configuración de un Virtual Machine Scale Set (VMSS) en Azure.
- **[outputs.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/compute/outputs.tf)**: Output que devuelve el ID del VMSS.
- **[variables.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/compute/variables.tf)**: Variables relevantes para la configuración del VMSS.

#### Módulo: Database
- **[main.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/database/main.tf)**: Creación de un servidor MySQL y una base de datos para WordPress.
- **[outputs.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/database/outputs.tf)**: Output que devuelve el ID del servidor de base de datos.
- **[varaibles.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/database/varaibles.tf)**: Variables para la configuración del servidor MySQL.

#### Módulo: Network
- **[main.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/network/main.tf)**: Configuración de la Virtual Network (VNet) y subredes en Azure.
- **[outputs.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/network/outputs.tf)**: Outputs que devuelven los IDs de la VNet y subredes.
- **[varaibles.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/network/varaibles.tf)**: Variables para la configuración de la VNet y subredes.

#### Módulo: Security
- **[main.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/security/main.tf)**: Configuración del Network Security Group (NSG) y monitoreo de recursos.
- **[outputs.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/security/outputs.tf)**: Output que devuelve el ID del NSG.
- **[variables.tf](https://github.com/DanielMCLum/ProFiCurs/blob/Rub%C3%A9n/azure-wordpress-infra/modules/security/variables.tf)**: Variables para la configuración de seguridad y monitoreo.

---

## Uso del Proyecto

### Pasos para Implementar

1. **Configurar Variables**: Personaliza el archivo `terraform.tfvars` con los valores necesarios para tu entorno.

## Despliegue de la infraestructura
```bash
terraform init        # Inicializa el entorno Terraform
terraform plan        # Muestra los cambios antes de aplicar
terraform apply       # Despliega la infraestructura
terraform destroy     # Elimina la infraestructura si es necesario
```
### Recursos Incluidos
    Red: VNet, subredes públicas y privadas.
    Cómputo: Virtual Machine Scale Set para soportar la aplicación.
    Base de Datos: Servidor MySQL con una base de datos para WordPress.
    Seguridad: Configuración de Network Security Groups.

## Gestión del estado de Terraform en Azure  

Terraform almacena su estado de infraestructura en **Azure Storage**, lo que permite un control centralizado y seguro del estado del despliegue.  

### **Configuración del backend en `terraform.tf`**  
El estado de Terraform se almacena en un **Azure Storage Account**, dentro de un contenedor llamado `tfstate`.  

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "terraformstate"
  container_name       = "tfstate"
  key                  = "azure-wordpress-infra.tfstate"
}
```
## Outputs de la infraestructura en Terraform  

Terraform genera **outputs** para facilitar el acceso a recursos críticos de la infraestructura. Estos valores permiten referenciar identificadores únicos de cada módulo.  

### **Outputs generados**  

✅ **`vnet_id`** → ID de la VNet creada.  
✅ **`vmss_id`** → ID del VM Scale Set para gestionar múltiples instancias.  
✅ **`db_id`** → ID del servidor de base de datos para conectividad con la aplicación.  
✅ **`nsg_id`** → ID del Network Security Group, encargado de la protección de accesos.  

### **Uso de los outputs en Terraform**  
Puedes obtener los valores de los outputs ejecutando:  
```bash
terraform output
```
## Configuración del proveedor de Terraform  

Este proyecto utiliza Terraform para gestionar infraestructura en **Microsoft Azure**, aprovechando el proveedor `azurerm` de HashiCorp.  

### **Configuración del proveedor en `terraform.tf`**  
Definimos el proveedor `azurerm`, asegurando que la versión utilizada sea compatible con Terraform.  

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```
## Variables utilizadas en Terraform  

Este proyecto define variables para parametrizar la infraestructura y facilitar su reutilización en múltiples entornos.  

### **Lista de variables y su propósito**  

✅ **`location`** → Ubicación donde se desplegarán los recursos en Azure.  
✅ **`resource_group_name`** → Nombre del grupo de recursos donde se gestionará la infraestructura.  
✅ **`admin_username`** → Usuario administrador para acceso a las máquinas virtuales.  
✅ **`admin_password`** → Contraseña del usuario administrador.  
✅ **`vm_size`** → Tamaño de las máquinas virtuales desplegadas.  
✅ **`instance_count`** → Número de instancias de máquinas virtuales a aprovisionar.  

### **Uso de las variables en Terraform**  
Las variables permiten definir valores reutilizables en la infraestructura.  
Para aplicar configuraciones con valores personalizados, se puede usar un archivo `terraform.tfvars`:  

```hcl
location            = "East US"
resource_group_name = "mi-grupo-recursos"
admin_username      = "admin"
admin_password      = "supersegura123"
vm_size             = "Standard_B2s"
instance_count      = 2
```

## Configuración de variables en Terraform  

Para personalizar el despliegue de la infraestructura, se utiliza un archivo `terraform.tfvars`, donde se definen valores específicos para las variables del proyecto.  

### **Ejemplo de configuración (`terraform.tfvars`)**  
```hcl
location            = "East US"
resource_group_name = "wordpress-rg"
admin_username      = "azureuser"
admin_password      = "SecurePassword123!"
vm_size             = "Standard_B2s"
instance_count      = 2
```
terraform apply -var-file="terraform.tfvars"

## Módulo de Cómputo: Virtual Machine Scale Set (VMSS)  

Este módulo define un **VM Scale Set** en Azure para alojar múltiples instancias de máquinas virtuales que se gestionan de manera escalable y automatizada.  

### **Configuración clave del VMSS**  

✅ **Tamaño y capacidad** → Define el número de instancias y recursos asignados.  
✅ **Perfil de sistema operativo** → Configura usuarios y credenciales de administración.  
✅ **Red y conectividad** → Asigna IPs y subredes a las máquinas virtuales.  
✅ **Actualización automática** → Implementa mejoras en las instancias sin intervención manual.  

### **Uso en Terraform**  
Para desplegar el VMSS:  
```bash
terraform apply
```

## Outputs del módulo de cómputo  

Este módulo genera un **output** que permite acceder fácilmente al ID del **Virtual Machine Scale Set (VMSS)** creado en Azure.  

### **Output generado**  
✅ **`vmss_id`** → Identificador único del VMSS, necesario para gestionar la infraestructura.  

### **Uso del output en Terraform**  
Puedes consultar el valor del output con:  
```bash
terraform output vmss_id
```

## Variables utilizadas en el módulo de cómputo  

Este módulo define variables que permiten la configuración flexible del **VM Scale Set (VMSS)** en Azure.  

### **Lista de variables y su propósito**  

✅ **`vmss_name`** → Nombre del VM Scale Set.  
✅ **`location`** → Ubicación donde se despliega la infraestructura.  
✅ **`resource_group_name`** → Grupo de recursos donde se gestionan los componentes.  
✅ **`vm_size`** → Tamaño de las máquinas virtuales.  
✅ **`instance_count`** → Número de instancias iniciales en el VMSS.  
✅ **`admin_username`** → Usuario administrador de las máquinas virtuales.  
✅ **`admin_password`** → Contraseña segura para acceso remoto.  
✅ **`subnet_id`** → Identificador de la subred donde se conectan las VMs.  

### **Uso de las variables en Terraform**  
Las variables permiten ajustar configuraciones sin modificar directamente los archivos `.tf`.  

Para aplicar valores personalizados, se recomienda definir un archivo `terraform.tfvars`:  
```hcl
vmss_name            = "wordpress-vmss"
location             = "East US"
resource_group_name  = "wordpress-rg"
vm_size              = "Standard_B2s"
instance_count       = 2
admin_username       = "azureuser"
admin_password       = "SecurePassword123!"
subnet_id            = "subnet-123456"
```
## Módulo de Base de Datos: MySQL en Azure  

Este módulo define la infraestructura de base de datos utilizando **Azure Database for MySQL** para alojar datos de la aplicación.  

### **Recursos creados en este módulo**  

✅ **Servidor MySQL** → Instancia MySQL 8.0 con almacenamiento definido.  
✅ **Base de datos** → Configuración con charset UTF-8 y collation adecuada.  
✅ **Administración segura** → Credenciales protegidas para acceso controlado.  

### **Uso del módulo en Terraform**  
Para desplegar la base de datos en Azure:  
```bash
terraform apply
```

## Outputs del módulo de base de datos  

Este módulo genera un **output** que proporciona acceso al ID del **servidor MySQL** creado en Azure.  

### **Output generado**  
✅ **`db_id`** → Identificador único del servidor de base de datos.  

### **Uso del output en Terraform**  
Puedes consultar el valor del output con:  
```bash
terraform output db_id
```

## Variables utilizadas en el módulo de base de datos  

Este módulo define variables para gestionar la configuración de un servidor MySQL en **Azure Database for MySQL**.  

### **Lista de variables y su propósito**  

✅ **`db_name`** → Nombre de la base de datos creada.  
✅ **`location`** → Ubicación de la infraestructura en Azure.  
✅ **`resource_group_name`** → Grupo de recursos donde se aloja el servidor de base de datos.  
✅ **`db_sku`** → SKU que define la capacidad y rendimiento de la base de datos.  
✅ **`storage_mb`** → Espacio de almacenamiento asignado (en megabytes).  
✅ **`admin_username`** → Usuario administrador con privilegios de gestión.  
✅ **`admin_password`** → Contraseña segura para acceso al servidor.  

### **Uso de las variables en Terraform**  
Para definir valores personalizados en un archivo `terraform.tfvars`:  

```hcl
db_name             = "wordpress-db"
location           = "East US"
resource_group_name = "wordpress-rg"
db_sku             = "B_Gen5_2"
storage_mb         = 5120
admin_username     = "azureuser"
admin_password     = "SecurePassword123!"
```
## Módulo de Red: Virtual Network y Subredes en Azure  

Este módulo define una **Virtual Network (VNet)** en Azure junto con subredes públicas y privadas para segmentar la infraestructura de manera segura y eficiente.  

### **Recursos creados en este módulo**  

✅ **Red Virtual (VNet)** → Espacio de direcciones IP para la infraestructura.  
✅ **Subred Pública** → Permite el acceso a recursos expuestos a internet.  
✅ **Subred Privada** → Segmentación interna para servicios con restricciones de acceso.  

### **Uso del módulo en Terraform**  
Para desplegar la red en Azure:  
```bash
terraform apply
```

## Outputs del módulo de red  

Este módulo genera **outputs** que proporcionan acceso a los identificadores únicos de los elementos de red creados en Azure.  

### **Outputs generados**  
✅ **`vnet_id`** → Identificador de la Virtual Network (VNet).  
✅ **`public_subnet_id`** → Identificador de la subred pública.  
✅ **`private_subnet_id`** → Identificador de la subred privada.  

### **Uso de los outputs en Terraform**  
Puedes consultar los valores de los outputs ejecutando:  
```bash
terraform output
```

## Variables utilizadas en el módulo de red  

Este módulo define variables para gestionar la configuración de una **Virtual Network (VNet)** y sus subredes en Azure.  

### **Lista de variables y su propósito**  

✅ **`vnet_name`** → Nombre de la Virtual Network (VNet).  
✅ **`location`** → Ubicación donde se despliega la infraestructura.  
✅ **`resource_group_name`** → Grupo de recursos donde se gestiona la VNet.  
✅ **`address_space`** → Espacio de direcciones IP para la red virtual.  
✅ **`public_subnet_name`** → Nombre de la subred pública.  
✅ **`public_subnet_prefix`** → Prefijo de direcciones IP para la subred pública.  
✅ **`private_subnet_name`** → Nombre de la subred privada.  
✅ **`private_subnet_prefix`** → Prefijo de direcciones IP para la subred privada.  

### **Uso de las variables en Terraform**  
Para definir valores personalizados en un archivo `terraform.tfvars`:  

```hcl
vnet_name            = "wordpress-vnet"
location             = "East US"
resource_group_name  = "wordpress-rg"
address_space        = ["10.0.0.0/16"]
public_subnet_name   = "public-subnet"
public_subnet_prefix = ["10.0.1.0/24"]
private_subnet_name  = "private-subnet"
private_subnet_prefix = ["10.0.2.0/24"]
```

## Módulo de Seguridad en Azure  

Este módulo gestiona la seguridad de la infraestructura en Azure mediante la creación de un **Network Security Group (NSG)** y la configuración de **diagnóstico y monitoreo** para las instancias del VMSS.  

### **Recursos creados en este módulo**  

✅ **Network Security Group (NSG)** → Define reglas de tráfico y protección de accesos.  
✅ **Diagnóstico y monitoreo** → Envía métricas y logs al Azure Monitor Log Analytics.  

### **Uso del módulo en Terraform**  
Para desplegar los recursos de seguridad:  
```bash
terraform apply
```

## Outputs del módulo de seguridad  

Este módulo genera **outputs** que permiten acceder al identificador único del **Network Security Group (NSG)** en Azure.  

### **Outputs generados**  
✅ **`nsg_id`** → Identificador único del NSG, utilizado para gestionar reglas de seguridad y tráfico.  

### **Uso del output en Terraform**  
Para consultar el valor del output:  
```bash
terraform output nsg_id
```

## Variables utilizadas en el módulo de seguridad  

Este módulo define variables para gestionar la configuración del **Network Security Group (NSG)** y el **monitoreo** en Azure.  

### **Lista de variables y su propósito**  

✅ **`nsg_name`** → Nombre del grupo de seguridad de red.  
✅ **`location`** → Ubicación donde se despliega la configuración de seguridad.  
✅ **`resource_group_name`** → Grupo de recursos donde se gestiona la seguridad.  
✅ **`vmss_id`** → Identificador del VM Scale Set que será monitoreado.  
✅ **`workspace_id`** → ID del Log Analytics Workspace donde se almacenan métricas y registros.  

### **Uso de las variables en Terraform**  
Para definir valores personalizados en un archivo `terraform.tfvars`:  

```hcl
nsg_name            = "wordpress-nsg"
location            = "East US"
resource_group_name = "wordpress-rg"
vmss_id             = "vmss-12345"
workspace_id        = "workspace-67890"
```
