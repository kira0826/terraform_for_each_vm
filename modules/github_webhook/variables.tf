variable "repository_name" {
  description = "Repository name"
  type        = string
}

variable "webhook_url" {
  description = "Jenkins webhook URL"
  type        = string
}

variable "webhook_secret" {
  description = "Secret para el webhook"
  type        = string
  sensitive   = true
}

variable "webhook_events" {
  description = "Weebhook trigger events"
  type        = list(string)
  default     = ["push"]
}

variable "active" {
  description = "Define if the webhook is active"
  type        = bool
  default     = true
}