# Configure remote backend for Terraform state in Azure Storage
# IMPORTANT: This storage account and container must be created manually ONCE
# before the first 'terraform init' in ADO.
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"       # Create this RG
    storage_account_name = "sttfstate001shirish" # CHOOSE A GLOBALLY UNIQUE NAME
    container_name       = "tfstate"
    key                  = "simple-app.tfstate"
  }
}