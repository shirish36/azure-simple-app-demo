terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a recent compatible version, e.g., 3.x or 4.x
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}