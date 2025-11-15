output "key_vault_uri" {
  value       = { for k, v in azurerm_key_vault.keyvault : k => v.vault_uri }
  description = "URI's of Key Vault"
}
