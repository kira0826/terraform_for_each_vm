
output "network_interface_ids" {
  description = "IDs of the network interfaces created"
  value       = { for k, v in azurerm_network_interface.devops_nic : k => v.id }
}


output "ip_servers" {
    description = "IP de los servidores"
    value = [for server in azurerm_public_ip.devops_ip : {"name": server.name, "ip" : server.ip_address}]
} 