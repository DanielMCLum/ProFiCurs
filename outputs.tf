Explicación detallada:
Propósito:

Estos outputs muestran las direcciones IP públicas asignadas a las instancias EC2 creadas.

Son esenciales para poder conectarse a los servidores después del despliegue.

ansible_public_ip:

Muestra la IP pública de la instancia ansible_host

Esta IP te permitirá:

Conectarte por SSH para administrar Ansible

Acceder al servidor donde está instalado Ansible

wordpress_public_ip:

Muestra la IP pública de la instancia wordpress_host

Con esta IP podrás:

Acceder al futuro sitio de WordPress (vía HTTP)

Conectarte por SSH para configuraciones manuales

Cómo se visualizan:

Al ejecutar terraform apply, estas IPs aparecerán al final de la salida

También puedes verlas después con terraform output

Uso práctico:

Copia estas IPs para:

Configurar tu cliente SSH

Acceder al WordPress (después de instalarlo)

Configurar inventarios de Ansible

Estos outputs son especialmente útiles porque las IPs públicas de las instancias EC2 normalmente cambian cada vez que se detienen y arrancan (a menos que uses una IP elástica).


output "ansible_public_ip" {
  value = aws_instance.ansible_host.public_ip
}

output "wordpress_public_ip" {
  value = aws_instance.wordpress_host.public_ip
}
