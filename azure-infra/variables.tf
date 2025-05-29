variable "resource_group_name" {
  description = "Name of the main resource group."
  type        = string
  default     = "rg-simple-app-prod-001"
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "eastus" # Choose a region close to you
}

variable "sql_admin_username" {
  description = "SQL Server admin username."
  type        = string
  default     = "sqladmin" # Use a secure, non-default name in production
}

variable "sql_admin_password" {
  description = "SQL Server admin password."
  type        = string
  sensitive   = true # Mark as sensitive for security
}