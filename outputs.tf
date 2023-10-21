output ip {
  value       = module.vm.ip_machines
  sensitive   = false
  description = "ip Public"
}
