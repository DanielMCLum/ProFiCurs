## Configuración de variables en Terraform  

Para personalizar el despliegue de la infraestructura, se utiliza un archivo `terraform.tfvars`, donde se definen valores específicos para las variables del proyecto.

# Definición de la ubicación donde se desplegará la infraestructura en Azure
location            = "East US"

# Nombre del grupo de recursos donde se gestionarán todos los servicios
resource_group_name = "wordpress-rg"

# Usuario administrador para las máquinas virtuales
admin_username      = "azureuser"

# Contraseña segura para el usuario administrador
admin_password      = "SecurePassword123!"

# Tamaño de las máquinas virtuales utilizadas en la infraestructura
vm_size             = "Standard_B2s"

# Número de instancias que se aprovisionarán en el despliegue inicial
instance_count      = 2
