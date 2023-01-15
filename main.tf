# Configure the Azure provider and TF cloud
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

  /*
  cloud {
    organization = "Pines"
    workspaces {
      name = "development-workspace"
    }
  }
*/

}

provider "azurerm" {
  features {}
}


# refer to a resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#refer to a subnet
data "azurerm_subnet" "devTF-pub-subnet" {
  name                 = var.subnet_id
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

output "subnet_id" {
  value = data.azurerm_subnet.devTF-pub-subnet.id
}

#creates public IP
resource "azurerm_public_ip" "WIN-ip" {
  name                = "WIN-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location_name
  allocation_method   = "Dynamic"

  tags = {
    Environment = "Dev"
  }
}

#creates network interface
resource "azurerm_network_interface" "WIN-nic" {
  name                = "WIN-nic"
  location            = var.location_name
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.devTF-pub-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.WIN-ip.id
  }

  tags = {
    "Environment" = "Dev"
  }
}

#creates a windows virtual machine
resource "azurerm_windows_virtual_machine" "devTF-WIN-VM" {
  name                = "devTF-winserver"
  resource_group_name = var.resource_group_name
  location            = var.location_name
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "@Admin0123456789"
  network_interface_ids = [
    azurerm_network_interface.WIN-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-Datacenter"
    version   = "latest"
  }
  tags = {
    "Environment" = "Dev"
  }
}

#data source pub ip
/*
data "azurerm_public_ip" "devTF-ip-data" {
  name                = azurerm_public_ip.devTF-ip.name
  resource_group_name = var.resource_group_name
}
#create output
output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.devTF-VM.name}:${data.azurerm_public_ip.devTF-ip-data.ip_address}"

}
*/