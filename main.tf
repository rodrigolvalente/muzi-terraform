resource "azurerm_resource_group" "muzi-rg" {
  name     = local.rg-name
  location = var.location

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_security_group" "muzi-nsg" {
  name                = local.nsg-name
  resource_group_name = azurerm_resource_group.muzi-rg.name
  location            = azurerm_resource_group.muzi-rg.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }

}

resource "azurerm_subnet" "muzi-sn" {
  count = length(var.subnet-list)

  name                 = "${local.sn-name}-${format("%02s", count.index + 1)}"
  resource_group_name  = azurerm_resource_group.muzi-rg.name
  virtual_network_name = azurerm_virtual_network.muzi-vnet.name
  address_prefixes     = [var.subnet-list[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.muzi-sn[1].id
  network_security_group_id = azurerm_network_security_group.muzi-nsg.id
}

resource "azurerm_virtual_network" "muzi-vnet" {
  name                = local.vnet-name
  resource_group_name = azurerm_resource_group.muzi-rg.name
  location            = azurerm_resource_group.muzi-rg.location
  address_space       = ["10.1.0.0/16"]

  tags = {
    Environment = var.environment
  }
}
