output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "web_app_url" {
  value = azurerm_linux_web_app.web_app.default_hostname
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_db_name" {
  value = azurerm_mssql_database.main.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.web_app.name
}