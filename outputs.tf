output ip {
  value       = azurerm_public_ip.ip.ip_address
  sensitive   = false
  description = "ip Public"
}
