resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "plan-${var.resource_group_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux" # Using Linux for simpler web app deployment
  sku_name            = "B1"    # Basic tier, 1 instance (cost-effective for demo)

  tags = {
    environment = "dev"
    purpose     = "simple-app"
  }
}

# Azure Web App
resource "azurerm_linux_web_app" "web_app" {
  name                = "app-simple-hello-${random_string.suffix.result}" # Unique name required
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {
    application_stack {
      # Choose the runtime for your "Hello World" app. Example:
      # If using a simple HTML file, no specific stack is needed or you can pick PHP/Node.js to host it.
      # For a simple 'index.html', the 'static' app type is not directly available via Terraform,
      # but an empty Linux App Service Plan will host static content.
      # dotnet_version = "6.0" # If your hello world is C# .NET
      # node_version   = "16-lts" # If your hello world is Node.js
      # python_version = "3.9" # If your hello world is Python
      php_version = "8.0" # A common general purpose runtime
    }
  }

  app_settings = {
    # Connection string for your web app to connect to SQL DB
    "SQL_CONNECTION_STRING" = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  tags = {
    environment = "dev"
    application = "simple-hello-world"
  }
}

# Azure SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "sqlsvr-${var.resource_group_name}" # Unique SQL server name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0" # SQL Server version (e.g., 12.0 for Azure SQL Database)
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  public_network_access_enabled = true # For simplicity, enable public access for now. In production, use VNet Integration + Private Link.

  tags = {
    environment = "dev"
    purpose     = "app-data"
  }
}

# Azure SQL Database
resource "azurerm_mssql_database" "main" {
  name           = "db-${var.resource_group_name}"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "GP_Gen5_2" # General Purpose, Gen5 hardware, 2 vCores (cost-effective)

  tags = {
    environment = "dev"
    purpose     = "app-data"
  }
}

# SQL Server Firewall Rule (to allow access from Azure services and your IP)
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.main.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0" # This allows all Azure services to connect. Be careful with public IPs.
}

# Optional: Add a firewall rule for your current public IP to connect from your machine (if needed)
# resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
#   name                = "AllowMyIP"
#   server_id           = azurerm_mssql_server.main.id
#   start_ip_address    = "YOUR_PUBLIC_IP_ADDRESS" # Replace with your current public IP
#   end_ip_address      = "YOUR_PUBLIC_IP_ADDRESS"
# }

# Helper to generate a unique suffix for app names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}