# Genera una nueva clave privada SSH utilizando el algoritmo RSA con una longitud de 4096 bits
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"      # Tipo de algoritmo de clave (RSA)
  rsa_bits  = 4096       # Longitud de la clave: mayor número = mayor seguridad
}

# Guarda la clave privada en un archivo local llamado devops.pem con permisos seguros (0600)
resource "local_file" "private_key" {
  filename        = "${path.module}/devops.pem"                  # Ruta del archivo a guardar
  content         = tls_private_key.ssh_key.private_key_pem      # Contenido del archivo: clave privada generada
  file_permission = "0600"                                       # Permisos seguros: solo el propietario puede leer/escribir
}

# Registra la clave pública en AWS como un Key Pair, que luego se usará para acceder a instancias EC2
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name                                      # Nombre del Key Pair en AWS (usamos una variable)
  public_key = tls_private_key.ssh_key.public_key_openssh        # Clave pública en formato OpenSSH
}

