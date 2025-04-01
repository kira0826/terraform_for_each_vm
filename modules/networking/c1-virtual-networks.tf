resource "azurerm_public_ip" "devops_ip" {
    for_each = var.servers_network
    name                = "${each.value}-public-ip"
    location            = var.location_netwrok
    resource_group_name = var.resource_group_name_network
    allocation_method   = "Static"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix_name_network}-network"
  location            = var.location_netwrok
  resource_group_name = var.resource_group_name_network
  address_space       = [var.virtual_network_address]
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix_name_network}-subnet"
  resource_group_name  = var.resource_group_name_network
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address]
}
