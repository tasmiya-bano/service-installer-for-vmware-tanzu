resource "azurerm_network_interface" "this" {
  name                = "nic-${var.prefix_short}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ipcfg-${var.prefix_short}-${count.index}"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = azurerm_resource_group.this.tags

  lifecycle {
    ignore_changes = [
      tags["StartDate"],
    ]
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# Create (and display) an SSH key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_machine_extension" "this" {
  name                 = "bind_prereqs"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  auto_upgrade_minor_version = false

  settings = <<SETTINGS
    {
        "script": "${filebase64("${path.module}/setup.sh")}"
    }
SETTINGS
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "this" {
  name                       = "vm-${var.prefix_short}-bootstrap-0"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  network_interface_ids      = [azurerm_network_interface.this.id]
  size                       = "Standard_B2ms"
  allow_extension_operations = true

  os_disk {
    name                 = "os-${var.prefix_short}0"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.prefix_short}0"
  admin_username                  = "azureuser"
  admin_password                  = "n0tP@ssword"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.this.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.bootdiag.primary_blob_endpoint
  }

  tags = azurerm_resource_group.this.tags

  lifecycle {
    ignore_changes = [
      tags["StartDate"],
    ]
  }
}