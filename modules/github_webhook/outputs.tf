output "webhook_id" {
  description = "ID del webhook creado"
  value       = github_repository_webhook.webhook.id
}

output "webhook_url" {
  description = "URL configurada para el webhook"
  value       = var.webhook_url
  sensitive   = true
}