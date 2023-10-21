
variable unique_id {
    type = set(string)
    description = "unique identifier to ensure unique names"
}

variable ip_name {
  type        = string
  description = "ip name"
}

variable resource_group_name {
  type        = string
  description = "resource group name"
}
variable resource_group_location {
  type        = string
  description = "resource group location"
}

variable location {
  type        = string
  description = "location"
}
variable inter {
  type        = string
  description = "interface"
}
variable subnet_id {
  type        = string
  description = "subnet id"
}
variable securitygrp {
  type        = string
  description = "security group name"
}

variable securityrule {
  type        = string
  description = "security rule"
}

