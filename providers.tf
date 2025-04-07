terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"  
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Define how to connect to github account
provider "github" {
  token = var.github_token
  owner = var.github_owner
}


