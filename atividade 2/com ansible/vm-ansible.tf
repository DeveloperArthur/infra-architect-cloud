resource "azurerm_public_ip" "exampleansible" {
    name = "acceptanceTestPublicIp1ansible"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
}

resource "azurerm_network_interface" "mainansible" {
    name = "tf-nic-ansible"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name = "testconfiguration1"
      subnet_id = azurerm_subnet.internal.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.exampleansible.id
    }
}

resource "azurerm_network_interface_security_group_association" "exampleansible" {
    network_interface_id = azurerm_network_interface.mainansible.id
    network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_virtual_machine" "mainansible" {
    name = "tf-vm-ansible"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.mainansible.id]
    vm_size = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  } 
  storage_os_disk {
    name = "myosdisk1ansible"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {      
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "null_resource" "upload" {
    triggers = {
        order = azurerm_virtual_machine.mainansible.id
    }

    provisioner "file" {
        connection {
            type = "ssh"
            user = "testadmin"
            password = "Password1234!"
            host = azurerm_public_ip.exampleansible.ip_address
        }
        source = "ansible"
        destination = "/home/testadmin"
    }
}

resource "null_resource" "aptansible" {
    triggers = {
        order = null_resource.upload.id
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "testadmin"
            password = "Password1234!"
            host = azurerm_public_ip.exampleansible.ip_address
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y software-properties-common",
            "sudo apt-add-repository --yes --update ppa:ansible/ansible",
            "sudo apt-get -y install python3 ansible",
            "ansible-playbook -i /home/testadmin/ansible/inventario /home/testadmin/ansible/playbook.yaml"
        ]
    }
}