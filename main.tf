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
