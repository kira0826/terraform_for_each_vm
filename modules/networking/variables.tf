variable "servers_network" {
  description = "Mapa de servidores para los cuales crear IPs públicas"
  type        = set(string)
}

variable "location_netwrok" {
  description = "Región de Azure donde se crearán los recursos"
  type        = string
  default     = "eastus"
}

variable "resource_group_name_network" {
  description = "Nombre del grupo de recursos donde se crearán las IPs públicas"
  type        = string
}


variable "prefix_name_network" {
  type        = string
  description = "prefijo para nombres de recursos"
}

variable "virtual_network_address" {
  type        = string
  description = "prefijo para nombres de recursos"
}

variable "subnet_address" {
  type        = string
  description = "prefijo para nombres de recursos"
}