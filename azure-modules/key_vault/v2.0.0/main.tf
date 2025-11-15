# This module helps us to create Azure Key Vault Resource

locals {
  acl_subnet_list = flatten([
    for sn_k, sn_v in var.key_vault_variables :
    [
      for snet_list in coalesce(sn_v.key_vault_network_acls_virtual_networks, []) : [
        ["${sn_k},/subscriptions/${snet_list.key_vault_network_acls_virtual_networks_subscription_id}/resourceGroups/${snet_list.key_vault_network_acls_virtual_networks_virtual_network_rg_name}/providers/Microsoft.Network/virtualNetworks/${snet_list.key_vault_network_acls_virtual_networks_virtual_network_name}/subnets/${snet_list.key_vault_network_acls_virtual_networks_subnet_name}"]
      ]
    ]
  ])
  acl_final_list = { for k in local.acl_subnet_list : element(split(",", k), 0) => element(split(",", k), 1)... }

  # As running on Azure Cloudshell doesn't populate the user ObjectID , we need the below workaround
  # deploy_user_object_id = { for k, v in var.key_vault_variables : k => length(data.azurerm_client_config.current.object_id) > 0 && v.key_vault_access_container_agent_name == null ? data.azurerm_client_config.current.object_id : data.azuread_service_principal.agent_object_id[k].object_id }
  # self_access_policy    = { for k, v in var.key_vault_variables : k => v if lookup(v, "key_vault_access_container_agent_name", null) != null }
}

# data "azuread_service_principal" "agent_object_id" {
#   for_each     = { for k, v in var.key_vault_variables : k => v if lookup(v, "key_vault_access_container_agent_name", null) != null }
#   display_name = each.value.key_vault_access_container_agent_name
# }

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  for_each                        = var.key_vault_variables
  name                            = each.value.key_vault_name
  location                        = each.value.key_vault_location
  resource_group_name             = each.value.key_vault_resource_group_name
  enabled_for_disk_encryption     = each.value.key_vault_enabled_for_disk_encryption
  enabled_for_deployment          = each.value.key_vault_enabled_for_deployment
  enabled_for_template_deployment = each.value.key_vault_enabled_for_template_deployment
  enable_rbac_authorization       = each.value.key_vault_enable_rbac_authorization
  public_network_access_enabled   = each.value.key_vault_public_network_access_enabled
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = each.value.key_vault_soft_delete_retention_days # other new features like this
  purge_protection_enabled        = each.value.key_vault_purge_protection_enabled
  sku_name                        = each.value.key_vault_sku_name
  dynamic "network_acls" {
    for_each = each.value.key_vault_network_acls_enabled == true ? [1] : []
    content {
      bypass                     = each.value.key_vault_network_acls_bypass
      default_action             = each.value.key_vault_network_acls_default_action
      ip_rules                   = each.value.key_vault_network_acls_ip_rules
      virtual_network_subnet_ids = lookup(local.acl_final_list, "${each.key}", null)
    }
  }

  dynamic "contact" {
    for_each = each.value.key_vault_contact_information_enabled == true ? [1] : []
    content {
      email = each.value.key_vault_contact_email
      name  = each.value.key_vault_contact_name
      phone = each.value.key_vault_contact_phone
    }
  }

  tags = merge(each.value.key_vault_tags, tomap({ Created_Time = formatdate("DD-MM-YYYY hh:mm:ss ZZZ", timestamp()) }))
  lifecycle { ignore_changes = [
    tags["Created_Time"],
    contact] }
}

# resource "azurerm_key_vault_access_policy" "default_access" {
#   for_each                = local.self_access_policy
#   key_vault_id            = azurerm_key_vault.keyvault[each.key].id
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   object_id               = local.deploy_user_object_id[each.key]
#   application_id          = each.value.key_vault_access_policy_application_id
#   certificate_permissions = each.value.key_vault_access_policy_certificate_permissions
#   key_permissions         = each.value.key_vault_access_policy_key_permissions
#   secret_permissions      = each.value.key_vault_access_policy_secret_permissions
#   storage_permissions     = each.value.key_vault_access_policy_storage_permissions
# }