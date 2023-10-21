
# output ip {
#   value       = azurerm_public_ip.ip["machine1"].ip_address
#   sensitive   = false
#   description = "ip Public"
# } to select a particular IP

output "ip_machines" {
    description = "machine IPs"
    value = [for unique_id in azurerm_public_ip.ip : {"name": unique_id.id,"ip" : unique_id.ip_address}]
}