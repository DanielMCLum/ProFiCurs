variable "subscription_id" {
  type    = string
  default = "edc1a28f-3662-4c85-8f17-51258b8f150e"  # Reemplaza con tu ID
}

variable "resource_group_name" {
  type    = string
  default = "wordpressescalado_group"
}

variable "location" {
  type    = string
  default = "westus"
}

variable "vm_admin_username" {
  description = "Usuario administrador de las VMs"
  default     = "adminuser"
}