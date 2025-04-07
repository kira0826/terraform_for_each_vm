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
  type        = set(string)
  description = "nombre de los servidores que se van a desplegar"
}

variable "subscription_id" {
  type        = string
  description = "id de la suscripción"
}

# Github variables

variable "github_token" {

  type        = string
  description = "token de github"
  
}

variable "github_owner" {
  type        = string
  description = "owner de github"
}

variable "github_repo" {
  description = "Nombre del repositorio"
  type        = string
}

variable "webhook_secret" {
  description = "Secret para el webhook"
  type        = string
  sensitive   = true
}