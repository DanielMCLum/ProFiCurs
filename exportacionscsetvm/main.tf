# Grupo de recursos
resource "azapi_resource" "resource_group" {
  type      = "Microsoft.Resources/resourceGroups@2024-07-01"
  name      = var.resource_group_name
  location  = var.location
  parent_id = "/subscriptions/${var.subscription_id}"
  body      = { properties = {} }
}

# VM Scale Set
resource "azapi_resource" "vm_scale_set" {
  type      = "Microsoft.Compute/virtualMachineScaleSets@2024-07-01"
  name      = "wordpress-vmss"
  parent_id = azapi_resource.resource_group.id
  location  = var.location

  body = {
    sku = {
      name     = "Standard_B1ls"
      capacity = 2
    }
    properties = {
      virtualMachineProfile = {
        storageProfile = {
          imageReference = {
            publisher = "canonical"
            offer     = "ubuntu-24_04-lts"
            sku       = "server"
            version   = "latest"
          }
          osDisk = {
            caching      = "ReadWrite"
            createOption = "FromImage"
            diskSizeGB   = 30
            managedDisk  = { storageAccountType = "Premium_LRS" }
          }
        }
        osProfile = {
          adminUsername = var.vm_admin_username
          linuxConfiguration = {
            disablePasswordAuthentication = false
          }
        }
        networkProfile = {
          networkInterfaceConfigurations = [{
            name = "vmss-nic"
            properties = {
              ipConfigurations = [{
                name = "vmss-ipconfig"
                properties = {
                  subnet = {
                    id = azapi_resource.subnet.id  # Referencia a la subred
                  }
                }
              }]
            }
          }]
        }
      }
    }
  }

  depends_on = [
    azapi_resource.load_balancer,
    azapi_resource.network_security_group
  ]
}