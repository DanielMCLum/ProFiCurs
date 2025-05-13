
La declaración variable "region" en Terraform define una variable configurable con un valor predeterminado para especificar la región de AWS donde se desplegarán los recursos.


variable "region" {
  default = "us-east-1"
}

Qué hace exactamente:
Define una variable llamada "region":

Permite personalizar la región AWS sin modificar el código principal

El valor predeterminado es "us-east-1" (Norte de Virginia)

Cómo se usa:

La variable se referencia en el provider AWS como var.region

Si no se especifica otro valor, usará automáticamente us-east-1

Ventajas de usar variables:

Flexibilidad: Puedes cambiar la región fácilmente

Reutilización: El mismo código funciona para diferentes regiones

Claridad: Los parámetros configurables están bien documentados

Formas de asignar valores:

Acepta el valor predeterminado (us-east-1)

Sobrescribir temporalmente al aplicar:

bash
terraform apply -var="region=us-west-2"
Usar un archivo terraform.tfvars

Configurar variables de entorno

Buenas prácticas:

us-east-1 es común por su amplia disponibilidad

Para producción, considera usar regiones cercanas a tus usuarios

Algunos servicios/AMIs pueden ser específicos de región

Esta variable es particularmente útil cuando:

Quieres probar en diferentes regiones

Necesitas desplegar en múltiples regiones (usando módulos)

Colaboras con otros que prefieren regiones diferentes


