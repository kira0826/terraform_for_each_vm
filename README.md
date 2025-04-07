## Infrastructure Management

Infrastructure is managed using **Terraform** with the **Azurerm** provider, structured into three modular and reusable components:

1. **Networking**
2. **Virtual Machines**
3. **GitHub Integration**

![image.png](attachment:f56ed64e-a4c3-48ed-a6f1-8de5cdfb5f32:image.png)

This modular design enhances the **reusability** and **maintainability** of infrastructure components.

The **GitHub module** is particularly responsible for dynamically creating a **webhook** between the frontend repository and the Jenkins server. Since the public IP of the Jenkins server changes with every redeployment, using a DNS-based solution was avoided due to cost constraints.

### Webhook Creation with Terraform

To automate the webhook creation, the [GitHub provider](https://registry.terraform.io/providers/integrations/github/latest) is used, leveraging the `github_repository_webhook` resource:

```hcl
resource "github_repository_webhook" "webhook" {
  repository = "Teclado"

  configuration {
    url          = var.webhook_url
    content_type = "json"
    secret       = var.webhook_secret
    # Since Jenkins is running over HTTP, we must allow insecure SSL.
    insecure_ssl = true
  }

  active = var.active
  events = var.webhook_events
}

```

> insecure_ssl = true is enabled intentionally because Jenkins is running over HTTP.
> 
> 
> The `secret` is used to generate a hash signature, ensuring that the payload actually comes from the GitHub webhook and hasn’t been tampered with.
> 

### Webhook generated

![image.png](attachment:f1b3f6a0-b242-4ee0-905b-24059e57eda5:image.png)

### GitHub Provider Configuration

In order to authenticate and manage GitHub resources, a **GitHub personal access token (PAT)** is required. The provider must be configured as follows:

```hcl
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

```

The token must be manually created in GitHub with appropriate permissions:

> GitHub → Settings → Developer Settings → Personal Access Token
> 

![image.png](attachment:f7197fbc-efbf-4beb-acc8-f493f724923a:image.png)

Permissions required for webhook management:

- **repo** (for accessing private repositories if needed)
- **admin:repo_hook** (specifically for managing webhooks)

![image.png](attachment:c3f918b7-4cd6-43c8-abe7-0c44db460eaf:image.png)

Here’s an example `curl` command to verify that the token is authorized and working:

```bash
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/repos/YOUR_OWNER/Teclado

```

---

## Token Management & Provider Issues

A common issue arises when using multiple modules with the `github` provider: **Terraform may misinterpret which provider to use**, especially when other tools like `git` are involved.

To avoid this, the `required_providers` block must be explicitly declared in **both the module and the main configuration**. This ensures Terraform correctly maps to the `integrations/github` provider:

```hcl
# Inside the module
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Inside the main configuration
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

```

This resolves errors such as:

> 404 When Creating github_repository_webhook with Terraform
> 

Refer to the following issues for more details:

- [StackOverflow - 404 When Creating github_repository_webhook with Terraform](https://stackoverflow.com/questions/70897038/404-when-creating-github-repository-webhook-with-terraform)
- [GitHub Issue #696 - Using modules requires hashicorp/github](https://github.com/integrations/terraform-provider-github/issues/696)