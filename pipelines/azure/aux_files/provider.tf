terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.116.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.29.0"
    }
  }
}


provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  #subscription_id = "xx"
  subscription_id = var.provider_subscription_id
  # client_id       = "xx"
  # client_secret   = "x"
  #subscription_id = "xx"
  tenant_id       = "xx"
  use_msi = true
}
provider "azuread" {
  tenant_id = var.provider_tenant_id
  use_msi   = true
}
variable "provider_subscription_id" {
  type = string
}
variable "provider_tenant_id" {
  type = string
}