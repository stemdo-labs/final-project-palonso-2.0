output "public_ip" {
  value = length(azurerm_public_ip.public_ip) > 0 ? azurerm_public_ip.public_ip[0].ip_address : null
}
