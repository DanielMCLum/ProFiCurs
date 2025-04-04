// Por hacer

# Genera una nueva key
/*
resource "tls_private_key" "miClave" {
  algorithm = "RSA"
}

# Genera la clave publica
resource "aws_key_pair" "deployer" {
  key_name   = "wordpress"
  public_key = tls_private_key.miClave.public_key_openssh
}

# Guarda la clave publica
resource "null_resource" "save_key_pair"  {
	provisioner "local-exec" {
	    command = "echo  ${tls_private_key.miClave.private_key_pem} > mykey.pem"
  	}
}
*/