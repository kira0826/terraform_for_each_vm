resource "azurerm_linux_virtual_machine" "vm_devops" {
    for_each = var.servers
    name = "${each.value}-machine"
    resource_group_name = var.resource_group_name
    location = var.location
    size = var.size_servers
    # Must use each.key due to these values are equal to nics keys.
    network_interface_ids = [var.network_interface_ids_from_networking[each.key]]
    disable_password_authentication = false
    admin_username = var.user
    admin_password = var.password

  os_disk {
    name                 = "${each.value}Osdisk"
    caching              = "ReadWrite"  
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}