provider "azurerm" {
  version = "=2.7.0"
  features {}
}

resource "azurerm_resource_group" "LinktoIt-RG-Terraform" {
  name     = "terraform-resource-group"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "LinktoIt-ASP-TerraForm" {
  name                = "terraform-appserviceplan"
  location            = azurerm_resource_group.LinktoIt-RG-Terraform.location
  resource_group_name = azurerm_resource_group.LinktoIt-RG-Terraform.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "LinktoIt-AS-Terraform" {
  name                = "app-service-terraform"
  location            = azurerm_resource_group.LinktoIt-RG-Terraform.location
  resource_group_name = azurerm_resource_group.LinktoIt-RG-Terraform.name
  app_service_plan_id = azurerm_app_service_plan.LinktoIt-ASP-TerraForm.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_server.LinktoIttest.fully_qualified_domain_name} Database=${azurerm_sql_database.LinktoIttest.name};User ID=${azurerm_sql_server.LinktoIttest.administrator_login};Password=${azurerm_sql_server.LinktoIttest.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_sql_server" "LinktoIttest" {
  name                         = "terraform-sqlserver"
  resource_group_name          = azurerm_resource_group.LinktoIt-RG-Terraform.name
  location                     = azurerm_resource_group.LinktoIt-RG-Terraform.location
  version                      = "12.0"
  administrator_login          = "kashidsh"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "LinktoIttest" {
  name                = "terraform-sqldatabase"
  resource_group_name = azurerm_resource_group.LinktoIt-RG-Terraform.name
  location            = azurerm_resource_group.LinktoIt-RG-Terraform.location
  server_name         = azurerm_sql_server.LinktoIttest.name

  tags = {
    environment = "production"
  }
}
