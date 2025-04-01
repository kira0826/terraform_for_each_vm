variable "region" {
  type        = string
  description = "region de despliegue"
}

variable "prefix_name" {
  type        = string
  description = "prefijo para nombres de recursos"
}

variable "user" {
  type        = string
  description = "usuario ssh"
}

variable "password" {
  type        = string
  description = "password ssh"
}

variable "servers" {
  type        = list(string)
  description = "nombre de los servidores que se van a desplegar"
}

variable "subscription_id" {
  type        = string
  description = "id de la suscripción"
}