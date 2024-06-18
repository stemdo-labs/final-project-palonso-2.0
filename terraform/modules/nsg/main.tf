resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Permite el tráfico SSH (puerto 22) desde cualquier origen hacia cualquier destino
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Permite el tráfico MySQL (puerto 3306) desde cualquier origen hacia cualquier destino
  security_rule {
    name                       = "Allow-MySQL"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Permite el tráfico TCP desde la subred de la base de datos (10.0.2.0/24) hacia la subred de backup (10.0.3.0/24)
  security_rule {
    name                       = "allow_db_to_backup"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.3.0/24"
  }

  # Permite el tráfico TCP desde la subred de backup (10.0.3.0/24) hacia la subred de la base de datos (10.0.2.0/24)
  security_rule {
    name                       = "allow_backup_to_db"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.3.0/24"
    destination_address_prefix = "10.0.2.0/24"
  }

  # Permite todo el tráfico dentro de la red virtual (VirtualNetwork)
  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Permite el tráfico desde el balanceador de carga de Azure
  security_rule {
    name                       = "AllowAzureLoadBalancerInBound"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  # Deniega todo el tráfico entrante
  security_rule {
    name                       = "DenyAllInBound"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Permite todo el tráfico saliente dentro de la red virtual (VirtualNetwork)
  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 170
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Permite todo el tráfico saliente hacia Internet
  security_rule {
    name                       = "AllowInternetOutBound"
    priority                   = 180
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  # Deniega todo el tráfico saliente
  security_rule {
    name                       = "DenyAllOutBound"
    priority                   = 190
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
