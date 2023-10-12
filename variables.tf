
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
variable interface {
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

variable linuxm {
  type        = string
  description = "linux machine"
}

variable location {
  type        = string
  default     = "West Europe"
  description = "Location"
}