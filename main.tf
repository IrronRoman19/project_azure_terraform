resource "azurerm_resource_group" "rg_terraform_project" {
    name     = var.rg_name
    location = var.rg_location
}

resource "azurerm_virtual_network" "vnet_terraform_project" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg_terraform_project.location
  resource_group_name = azurerm_resource_group.rg_terraform_project.name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = var.sb_name_1
  resource_group_name  = azurerm_resource_group.rg_terraform_project.name
  virtual_network_name = azurerm_virtual_network.vnet_terraform_project.name
  address_prefixes     = [var.sb_1_address_prefix]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = var.sb_name_2
  resource_group_name  = azurerm_resource_group.rg_terraform_project.name
  virtual_network_name = azurerm_virtual_network.vnet_terraform_project.name
  address_prefixes     = [var.sb_2_address_prefix]
}

resource "azurerm_network_interface" "public_subnet_nic" {
  name                = var.nic_name_1
  location            = azurerm_resource_group.rg_terraform_project.location
  resource_group_name = azurerm_resource_group.rg_terraform_project.name

  ip_configuration {
    name                          = var.ipconfig_name_1
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address_1
    public_ip_address_id          = azurerm_public_ip.public_ip_for_public_subnet.id
  }
}

resource "azurerm_network_interface" "private_subnet_nic" {
  name                = var.nic_name_2
  location            = azurerm_resource_group.rg_terraform_project.location
  resource_group_name = azurerm_resource_group.rg_terraform_project.name

  ip_configuration {
    name                          = var.ipconfig_name_2
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address_2
  }
}

resource "azurerm_public_ip" "public_ip_for_public_subnet" {
  name                    = var.pip_vm_1
  location                = azurerm_resource_group.rg_terraform_project.location
  resource_group_name     = azurerm_resource_group.rg_terraform_project.name
  allocation_method       = "Dynamic"
}

resource "azurerm_network_security_group" "vm_nsg_1" {
  name                = var.nsg_name_1
  location            = var.rg_location
  resource_group_name = var.rg_name
  security_rule {
    name                        = var.nsg_rule_name_1
    priority                    = var.nsg_priority_1
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = var.nsg_dest_port_range_1
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    }
  depends_on = [azurerm_subnet.public_subnet, azurerm_network_interface.public_subnet_nic] 
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_1" {
  network_interface_id      = azurerm_network_interface.public_subnet_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg_1.id
}

resource "azurerm_network_security_group" "vm_nsg_2" {
  name                = var.nsg_name_2
  location            = var.rg_location
  resource_group_name = var.rg_name
  security_rule {
    name                        = var.nsg_rule_name_2_1
    priority                    = var.nsg_priority_1
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = var.nsg_dest_port_range_2_1
    source_address_prefix       = var.sb_1_address_prefix
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = var.nsg_rule_name_2_2
    priority                    = var.nsg_priority_2
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = var.nsg_dest_port_range_2_2
    source_address_prefix       = var.your_public_ip
    destination_address_prefix  = "*"
  }
  depends_on = [azurerm_subnet.private_subnet, azurerm_network_interface.private_subnet_nic] 
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_2" {
  network_interface_id      = azurerm_network_interface.private_subnet_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg_2.id
}

resource "azurerm_virtual_machine" "public_subnet_nic" {
  name                  = var.vm_name_1
  location              = azurerm_resource_group.rg_terraform_project.location
  resource_group_name   = azurerm_resource_group.rg_terraform_project.name
  network_interface_ids = [azurerm_network_interface.public_subnet_nic.id]
  vm_size               = "Standard_DS1_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name_1}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_name_1
    admin_username = var.vm_username
    admin_password = var.vm_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip git",
      "pip3 install flask psycopg2-binary",
      "export ip_address_2=${var.ip_address_2} >> ~/.bashrc",
      "export postgresql_db_name=${var.postgresql_db_name} >> ~/.bashrc",
      "export postgresql_username=${var.postgresql_username} >> ~/.bashrc",
      "export postgresql_password=${var.postgresql_password} >> ~/.bashrc",
      # git clone
    ]
  }

  
}

resource "azurerm_virtual_machine" "private_subnet_nic" {
  name                  = var.vm_name_2
  location              = azurerm_resource_group.rg_terraform_project.location
  resource_group_name   = azurerm_resource_group.rg_terraform_project.name
  network_interface_ids = [azurerm_network_interface.private_subnet_nic.id]
  vm_size               = "Standard_DS1_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name_2}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_name_2
    admin_username = var.vm_username
    admin_password = var.vm_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y postgresql postgresql-contrib",
      "sudo -u postgres psql -c \"CREATE ROLE ${var.postgresql_username} WITH LOGIN PASSWORD '${var.postgresql_password}';\"",
      "sudo -u postgres psql -c \"ALTER ROLE ${var.postgresql_username} CREATEDB;\"",  # Grant permissions to create databases
      "sudo -u postgres psql -c 'CREATE DATABASE ${var.postgresql_db_name};'",
      "sudo -u postgres psql -d ${var.postgresql_db_name} -c 'CREATE TABLE ${var.postgresql_table_name} (id SERIAL PRIMARY KEY, name VARCHAR(255), num_value INTEGER, date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP);'",
      "sudo -u postgres psql -d ${var.postgresql_db_name} -c \"INSERT INTO ${var.postgresql_table_name} (name, num_value) VALUES ('${var.postgresql_name_value_1}', ${var.postgresql_number_value_1});\"",
      "sudo -u postgres psql -d ${var.postgresql_db_name} -c \"INSERT INTO ${var.postgresql_table_name} (name, num_value) VALUES ('${var.postgresql_name_value_2}', ${var.postgresql_number_value_2});\"",
      "sudo -u postgres psql -d ${var.postgresql_db_name} -c \"INSERT INTO ${var.postgresql_table_name} (name, num_value) VALUES ('${var.postgresql_name_value_3}', ${var.postgresql_number_value_3});\"",
    ]
  }
}