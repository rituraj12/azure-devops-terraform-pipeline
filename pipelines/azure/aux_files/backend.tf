terraform {
  backend "azurerm" {
    tenant_id = "xx"
    # client_id = "xx"
    # client_secret = "xx"
    subscription_id = "xx"
    use_msi = true
  }
}