
# output ip {
#   value       = azurerm_public_ip.ip["machine1"].ip_address
#   sensitive   = false
#   description = "ip Public"
# } para seleccionar una ip en particular

output "ip_machines" {
    description = "IP de los servidores"
    value = [for unique_id in azurerm_public_ip.ip : {"name": unique_id.id,"ip" : unique_id.ip_address}]
}