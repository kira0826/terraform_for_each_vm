variable "servers" {
    type = set(string)
    description = "lista de servidores que vamos a desplegar"
}

variable "size_servers" {
    type = string
    default = "Standard_DS1_v2"
    description = "tamaño de instancia de los servidores"
}

variable "resource_group_name" {
    type = string
    description = "grupo de recursos de las vm"
}

variable "location" {
    type = string
    description = "region"
}

variable "user" {
    type = string
    description = "usuario ssh"
}

variable "password" {
    type = string
    description = "password ssh"
}

variable "prefix_name" {
    type = string
    description = "prefijo de los recursos"
}

variable "network_interface_ids_from_networking" {
  type = map(string)
}