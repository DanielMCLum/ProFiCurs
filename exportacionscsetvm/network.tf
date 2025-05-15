# Virtual Network
resource "azapi_resource" "vnet" {
  type      = "Microsoft.Network/virtualNetworks@2024-05-01"
  name      = "vnet-westus"
  parent_id = azapi_resource.resource_group.id
  location  = var.location

  body = {
    properties = {
      addressSpace = { addressPrefixes = ["172.16.0.0/16"] }
      subnets      = [
        {
          name          = "snet-westus-1"
          properties    = {
            addressPrefix = "172.16.0.0/24"
          }
        }
      ]
    }
  }
}

# Subred
resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "snet-westus-1"
  parent_id = azapi_resource.vnet.id

  body = {
    properties = {
      addressPrefix = "172.16.0.0/24"
    }
  }
}

# Network Security Group
resource "azapi_resource" "network_security_group" {
  type      = "Microsoft.Network/networkSecurityGroups@2024-05-01"
  name      = "wordpress-nsg"
  parent_id = azapi_resource.resource_group.id
  location  = var.location

  body = {
    properties = {
      securityRules = [
        {
          name = "allow-http"
          properties = {
            access                     = "Allow"
            direction                  = "Inbound"
            priority                   = 100
            protocol                   = "Tcp"
            sourceAddressPrefix        = "*"
            sourcePortRange            = "*"
            destinationAddressPrefix   = "*"
            destinationPortRange       = "80"
          }
        }
      ]
    }
  }
}

# Load Balancer
resource "azapi_resource" "load_balancer" {
  type      = "Microsoft.Network/loadBalancers@2024-05-01"
  name      = "wordpress-lb"
  parent_id = azapi_resource.resource_group.id
  location  = var.location

  body = {
    properties = {
      frontendIPConfigurations = [{
        name = "lb-frontend"
        properties = {
          publicIPAddress = {
            id = azapi_resource.public_ip.id  # Referencia a la IP pública
          }
        }
      }]
      backendAddressPools = [{
        name = "lb-backend"
      }]
    }
  }
}

# IP Pública
resource "azapi_resource" "public_ip" {
  type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
  name      = "wordpress-publicip"
  parent_id = azapi_resource.resource_group.id
  location  = var.location

  body = {
    properties = {
      publicIPAllocationMethod = "Static"
      publicIPAddressVersion   = "IPv4"
    }
    sku = { name = "Standard" }
  }
}
