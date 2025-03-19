terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This picks a random region from the list of regions.
resource "random_integer" "region_index" {
  max = length(local.azure_regions) - 1
  min = 0
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.azure_regions[random_integer.region_index.result]
  name     = module.naming.resource_group.name_unique
}

module "vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "~> 0.2.3"
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]
  subnets = {
    subnet0 = {
      name             = module.naming.subnet.name_unique
      address_prefixes = ["10.0.0.0/24"]
    }
  }
}

module "privatednszone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.1.2"

  domain_name         = "privatelink.monitor.azure.com"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_links = {
    vnetlink0 = {
      vnetlinkname = "dnslinktovnet"
      vnetid       = module.vnet.resource.id
    }
  }
}

# This is the module call
module "ampls" {
  source = "../../"

  enable_telemetry = var.enable_telemetry

  name                = "law-pl-service"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  private_endpoints = {
    pe_01 = {
      name                          = module.naming.private_endpoint.name_unique
      subnet_resource_id            = module.vnet.subnets["subnet0"].resource.id
      location                      = azurerm_resource_group.this.location
      private_dns_zone_resource_ids = [module.privatednszone.resource.id]
      network_interface_name        = "law-pl-service-pe-nic"
    }
  }
}
