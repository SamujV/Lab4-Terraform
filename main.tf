# Declaración del proveedor Azure
provider "azurerm" {
  features {}
}

# Creación de un grupo de recursos en Azure
resource "azurerm_resource_group" "rg" {
  name     = var.virtualmachine                 # Nombre del grupo de recursos
  location = var.location                       # Ubicación del grupo de recursos
}

# Creación de una red virtual en Azure
resource "azurerm_virtual_network" "vn" {  
  name                = var.virtualnetwork                       # Nombre de la red virtual
  address_space       = ["10.0.0.0/16"]                          # Rango de direcciones IP de la red
  location            = azurerm_resource_group.rg.location       # Ubicación heredada del grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name           # Nombre del grupo de recursos heredado
}

# Creación de una subred en la red virtual
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet                                    # Nombre de la subred
  resource_group_name  = azurerm_resource_group.rg.name                
  virtual_network_name = azurerm_virtual_network.vn.name               # Nombre de la red virtual heredado
  address_prefixes     = ["10.0.2.0/24"]                               # Rango de direcciones IP de la subred
}


module "vm" {
source = "./modules/vm"
ip_name = var.ip_name
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
inter = var.inter
resource_group_location = azurerm_resource_group.rg.location
subnet_id = azurerm_subnet.subnet.id
securitygrp = var.securitygrp
securityrule = var.securityrule
unique_id = var.unique_id
}




