terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "Lab_CR460"
    workspaces {
      name = "Devoir1"
    }
  }
}

provider "azurerm" {
  features {}
}

# 7 - Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-devoir01"
  location = "Canada East"
}
# 8 - Réseau Virtuel
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-devoir01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-devoir01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# 9 - Machine Virtuelle
resource "azurerm_network_interface" "nic" {
  name                = "nic-devoir01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-devoir01"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = "adminuser"
  admin_password                  = "Devoir01@Azure!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
