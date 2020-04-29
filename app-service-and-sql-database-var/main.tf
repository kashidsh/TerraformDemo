provider "azurerm" {
  version = "=2.7.0"
  features {}
}
resource "azurerm_resource_group" "skexample" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_cognitive_account" "sk123example" {
  name                = "example-account"
  location            = azurerm_resource_group.skexample.location
  resource_group_name = azurerm_resource_group.skexample.name
  kind                = "Face"

  sku_name = "S0"

  tags = {
    Acceptance = "Test"
  }
}
