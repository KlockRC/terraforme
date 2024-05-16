terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.103.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "cuzcuz-16052024"
  location = "East US"
}

# Crie um contêiner personalizado com uma porta aberta
resource "azurerm_container_group" "example_container_group" {
  name                = "ovocuzido"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  os_type       = "Linux"
  dns_name_label = "example-container-group"

  container {
    name   = "xerango"
    image  = "klockrc/dev-ops-29-02-2024-rg:tagname"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 5000
      protocol = "TCP"
    }
  }
}


resource "azurerm_mysql_flexible_server" "example_mysql_server" {
  name                = "smt-12"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "B_Gen5_1"  # SKU do servidor MySQL flexível
  version             = "5.7"

  administrator_login          = "admin"
  administrator_login_password = "Mudar123"
  
  # Configuração do firewall para permitir o acesso ao servidor MySQL
  public_network_access_enabled = true

  # Configuração do armazenamento
  storage_mb = 51200  # Define o tamanho do armazenamento em MB
}


# Crie um firewall para permitir o acesso ao servidor MySQL
resource "azurerm_mysql_firewall_rule" "example_firewall_rule" {
  name                = "firewall-smt-12"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example_mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
