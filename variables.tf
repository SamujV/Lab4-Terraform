
variable virtualmachine {
  type        = string
  description = "virtual machine"
}

variable virtualnetwork {
  type        = string
  description = "virtual network"
}
variable subnet {
  type        = string
  description = "subnet"
}
variable inter {
  type        = string
  description = "interface"
}
variable ip_name {
  type        = string
  description = "ip name"
}

variable securitygrp {
  type        = string
  description = "security group"
}

variable securityrule {
  type        = string
  description = "security rule"
}

variable location {
  type        = string
  default     = "West Europe"
  description = "Location"
}
variable unique_id {
  type        = set(string)
  description = "id for machines"
}


