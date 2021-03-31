resource "azurerm_network_interface" "muzi-nic" {
  name                = "muzi-nic"
  resource_group_name = azurerm_resource_group.muzi-rg.name
  location            = azurerm_resource_group.muzi-rg.location

  ip_configuration {
    name                          = "muzi-ip"
    subnet_id                     = azurerm_subnet.muzi-sn[1].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "muzi-vm" {
  name                  = "muzi-vm"
  resource_group_name   = azurerm_resource_group.muzi-rg.name
  location              = azurerm_resource_group.muzi-rg.location
  network_interface_ids = [azurerm_network_interface.muzi-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = local.computer_name
    admin_username = local.admin_username
    admin_password = local.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
  }
}