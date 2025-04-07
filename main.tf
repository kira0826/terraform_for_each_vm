resource "azurerm_resource_group" "main" {
  name     = "${var.prefix_name}-rg"
  location = var.region
}

module "networking" {
  source = "./modules/networking" # o la ruta correcta a tu módulo

  # Variables requeridas
  servers_network             = var.servers
  resource_group_name_network = azurerm_resource_group.main.name
  virtual_network_address     = "10.0.0.0/16"
  subnet_address              = "10.0.0.0/24"
  location_netwrok            = var.region
  prefix_name_network         = var.prefix_name
}
module "vm" {
  source                                = "./modules/vm"
  servers                               = var.servers
  size_servers                          = "Standard_DS1_v2"
  resource_group_name                   = azurerm_resource_group.main.name
  location                              = azurerm_resource_group.main.location
  prefix_name                           = var.prefix_name
  user                                  = var.user
  password                              = var.password
  network_interface_ids_from_networking = module.networking.network_interface_ids
}   

module "github_webhook" {
  source = "./modules/github_webhook"
  repository_name = var.github_repo
  # We must add the "github-webhook" prefix to the name of the webhook in order to
  # use the Jenkins github webhook plugin.
  webhook_url     = "http://${module.networking.devops_vm_ip}:8080/github-webhook/"
  webhook_secret  = var.webhook_secret
  webhook_events  = ["push"]
  
  # Must add this depens_on to ensure that the webhook is created after the VM has an IP.
  depends_on = [module.vm]
}