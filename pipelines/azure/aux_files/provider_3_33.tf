terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.33.0"
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
  # subscription_id = "xx"
  subscription_id = var.provider_subscription_id
  tenant_id = "xx"
  use_msi = true
}

variable "provider_subscription_id" {
  type = string
}
variable "provider_tenant_id" {
  type = string
}