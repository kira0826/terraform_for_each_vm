
# Define wich plugin to use

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Useful to obtain repository metadata
# Data is a terraform keyword to obtain information from a resource or a variable


resource "github_repository_webhook" "webhook" {

    
    repository = "Teclado"

    configuration {
      
        url = var.webhook_url
        content_type = "json"
        secret = var.webhook_secret
        # The insecure_ssl option is used to disable SSL verification for the webhook URL.
        # In this case is necessary due to jenkins server is using http.
        insecure_ssl = true
    }

    active = var.active
    events = var.webhook_events

}



