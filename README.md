# Connection with other projects

### Frontend, Jenkinsfile, and GitHub Actions Workflow

The [Teclado repository](https://github.com/kira0826/Teclado/) contains the entire frontend, which is deployed to a virtual machine using **Nginx**. The deployment is triggered by a **Jenkinsfile** executed by a Jenkins server hosted in a VM. This deployment process is automatically triggered after a **push to the `main` branch**, which can only occur **after a pull request is approved**.

Additionally, the repository includes a **GitHub Actions workflow** that runs whenever a pull request is created. This workflow performs a **code analysis using a SonarQube server**, which is deployed in the same VM as Jenkins. The results of the analysis are posted as comments on the pull request. Approval is **blocked until the analysis comments are available**, enforcing code quality gates.

A **Terraform-created webhook** notifies the Jenkins server whenever a push occurs in the frontend repository.

📁 [GitHub – kira0826/Teclado](https://github.com/kira0826/Teclado/)

---

### Provisioning with Ansible

Two virtual machines are provisioned using **Ansible**:

1. One dedicated to the **frontend deployment** using **Nginx**.
2. One dedicated to **DevOps services**, running **Jenkins** and **SonarQube** in Docker containers.

All services are fully automated for out-of-the-box functionality.

- **Jenkins** is configured using **Configuration as Code (JCasC)** to automatically create plugins and pipeline jobs.
- **SonarQube** setup includes automatic token generation through Ansible. This token is then securely added as a **GitHub secret** in the frontend repository, allowing GitHub Actions to authenticate and run code analysis pipelines.

### Key Ansible Roles:

1. **`devops_services`**
    
    Installs Docker Compose and starts containers for Jenkins, SonarQube, and PostgreSQL (used by SonarQube).
    
2. **`jenkins`**
    
    Automatically installs required Jenkins plugins via `plugins.txt` and sets up jobs using **Groovy scripts and JCasC**.
    
3. **`enable_nginx`**
    
    Prepares static frontend content, configures `nginx.conf` using templates, and exposes the application on port 80.
    
4. **`sonarqube`**
    
    Generates a SonarQube token and stores it as a **GitHub secret** in the frontend repository to enable code analysis during pull requests.
    

https://github.com/kira0826/ansible-pipeline
 
 ## Infrastructure Management

Infrastructure is managed using **Terraform** with the **Azurerm** provider, structured into three modular and reusable components:

1. **Networking**
2. **Virtual Machines**
3. **GitHub Integration**

![image](https://github.com/user-attachments/assets/cd6f45c3-5ba6-46cb-a3fd-6a6d02b4d21f)

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

![image](https://github.com/user-attachments/assets/39e5122f-f8d9-4a73-84b2-08cb5a00a2f7)


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

![image](https://github.com/user-attachments/assets/d4024619-a2a4-4697-93ad-d42981d065f3)


Permissions required for webhook management:

- **repo** (for accessing private repositories if needed)
- **admin:repo_hook** (specifically for managing webhooks)

![image](https://github.com/user-attachments/assets/4834e778-205e-43fa-ab8b-3d72e10e7022)


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
