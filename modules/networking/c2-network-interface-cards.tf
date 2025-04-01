
resource "azurerm_network_interface" "devops_nic" { 
    for_each = var.servers_network
    name                = "${each.value}-nic"
    location            = var.location_netwrok
    resource_group_name = var.resource_group_name_network

    ip_configuration {
    name                          = "${each.value}-configuration"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_ip[each.value].id
    }
}

resource "azurerm_network_security_group" "devops_sg" {
    name                = "${var.prefix_name_network}-sg"
    location            = var.location_netwrok
    resource_group_name = var.resource_group_name_network

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Sonar"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface_security_group_association" "devops_association" {
    for_each = var.servers_network
    network_interface_id      = azurerm_network_interface.devops_nic[each.value].id
    network_security_group_id = azurerm_network_security_group.devops_sg.id
}
