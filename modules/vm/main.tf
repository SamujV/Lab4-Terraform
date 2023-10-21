
# Creación de una dirección IP pública
resource "azurerm_public_ip" "ip" {
  for_each = var.unique_id
  name                = "ip_name_${each.value}"                                 # Nombre de la dirección IP pública
  resource_group_name = var.resource_group_name              
  location            = var.location          
  allocation_method   = "Static"                                    # Método de asignación estática
}

# Creación de una interfaz de red
resource "azurerm_network_interface" "interface" {
  for_each = var.unique_id
  name                = "inter_${each.value}"                              # Nombre de la interfaz de red.. "inter_${var.unique_id}"  
  location            = var.resource_group_location    
  resource_group_name = var.resource_group_name         

  ip_configuration {
    name                          = "internal"                     # Nombre de la configuración de IP
    subnet_id                     = var.subnet_id                  # ID de la subred asociada
    private_ip_address_allocation = "Dynamic"                      # Asignación de dirección IP privada dinámica
    public_ip_address_id = azurerm_public_ip.ip[each.value].id                # ID de la dirección IP pública
  }
}

# Creación de un grupo de seguridad de red
resource "azurerm_network_security_group" "sg" {
  for_each = var.unique_id
  name                = "securitygrp_${each.value}"                            # Nombre del grupo de seguridad de red
  location            = var.resource_group_location            
  resource_group_name = var.resource_group_name              

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
  for_each = var.unique_id
  network_interface_id      = azurerm_network_interface.interface[each.value].id          # ID de la interfaz de red
  network_security_group_id = azurerm_network_security_group.sg[each.value].id            # ID del grupo de seguridad de red
}



# Creación de una máquina virtual Linux
resource "azurerm_linux_virtual_machine" "linuxmach" {
  for_each = var.unique_id
  name                = "linuxm-${each.value}"                 
  resource_group_name = var.resource_group_name 
  location            = var.resource_group_location   
  size                = "Standard_F2"                                 # Tamaño de la máquina virtual
  admin_username      = "adminuser"                                   # Nombre de usuario administrativo
  admin_password      = "Password123"  
  disable_password_authentication = false                             # Deshabilitar autenticación de contraseña
  network_interface_ids = [
    azurerm_network_interface.interface[each.value].id,                           # ID de la interfaz de red
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
