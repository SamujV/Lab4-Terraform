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

# Creación de una interfaz de red
resource "azurerm_network_interface" "interface" {
  name                = var.inter                             # Nombre de la interfaz de red
  location            = azurerm_resource_group.rg.location    
  resource_group_name = azurerm_resource_group.rg.name        

  ip_configuration {
    name                          = "internal"                     # Nombre de la configuración de IP
    subnet_id                     = azurerm_subnet.subnet.id       # ID de la subred asociada
    private_ip_address_allocation = "Dynamic"                      # Asignación de dirección IP privada dinámica
    public_ip_address_id = azurerm_public_ip.ip.id                 # ID de la dirección IP pública
  }
}

# Creación de una dirección IP pública
resource "azurerm_public_ip" "ip" {
  name                = var.ip_name                                 # Nombre de la dirección IP pública
  resource_group_name = azurerm_resource_group.rg.name              
  location            = azurerm_resource_group.rg.location          
  allocation_method   = "Static"                                    # Método de asignación estática
}

# Creación de un grupo de seguridad de red
resource "azurerm_network_security_group" "sg" {
  name                = var.securitygrp                             # Nombre del grupo de seguridad de red
  location            = azurerm_resource_group.rg.location          
  resource_group_name = azurerm_resource_group.rg.name              

  # Definición de una regla de seguridad
  security_rule {
    name                       = var.securityrule                   # Nombre de la regla de seguridad
    priority                   = 1001                               # Prioridad de la regla
    direction                  = "Inbound"                          # Dirección de la regla
    access                     = "Allow"                            
    protocol                   = "Tcp"                              
    source_port_range          = "*"                                # Rango de puertos de origen
    destination_port_range     = "22"                               # Rango de puertos de destino
    source_address_prefix      = "*"                                # Prefijo de dirección de origen
    destination_address_prefix = "*"                                # Prefijo de dirección de destino
  }
}

# Asociación de la interfaz de red al grupo de seguridad de red
resource "azurerm_network_interface_security_group_association" "isgp" {
  network_interface_id      = azurerm_network_interface.interface.id          # ID de la interfaz de red
  network_security_group_id = azurerm_network_security_group.sg.id            # ID del grupo de seguridad de red
}

# Creación de una máquina virtual Linux
resource "azurerm_linux_virtual_machine" "linuxmach" {
  name                = var.linuxm                  
  resource_group_name = azurerm_resource_group.rg.name  
  location            = azurerm_resource_group.rg.location  
  size                = "Standard_F2"                                 # Tamaño de la máquina virtual
  admin_username      = "adminuser"                                   # Nombre de usuario administrativo
  admin_password      = "P@$$w0rd1234!"  
  disable_password_authentication = false                             # Deshabilitar autenticación de contraseña
  network_interface_ids = [
    azurerm_network_interface.interface.id,                           # ID de la interfaz de red
  ]

  # Configuración del disco del sistema operativo
  os_disk {
    caching              = "ReadWrite"                                # Caché de disco en modo lectura/escritura
    storage_account_type = "Standard_LRS"                             # Tipo de cuenta de almacenamiento
  }

  # Especificación de la imagen del sistema operativo
  source_image_reference {
    publisher = "Canonical"                                            # Editor de la imagen
    offer     = "0001-com-ubuntu-server-focal"                         # Oferta de la imagen
    sku       = "20_04-lts"                                            # SKU de la imagen
    version   = "latest"                                               # Versión de la imagen
  }
}
