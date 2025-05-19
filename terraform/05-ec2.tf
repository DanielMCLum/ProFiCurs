resource "aws_instance" "wordpress" {
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "wordpress-${count.index + 1}"
  }
}
