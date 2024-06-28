resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = element(var.subnet_names, count.index)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.subnet_prefixes, count.index)]
}

output "subnet_ids" {
  value = azurerm_subnet.subnet[*].id
}
