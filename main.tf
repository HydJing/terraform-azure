# This 'terraform' block configures global settings for your Terraform project.
# It specifies the cloud providers you'll use and their versions.
terraform {
  required_providers {
    # The AzureRM provider is used to manage resources in Microsoft Azure.
    # Pinning to a specific version (e.g., "=3.0.0") ensures consistent deployments.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  # Uncomment and configure a 'backend' block here for remote state management
  # (e.g., Azure Storage Blob) in production environments for collaboration and safety.
  # backend "azurerm" { ... }
}

# This 'provider' block configures the Azure provider.
# It's where you can set authentication details or specific provider features.
provider "azurerm" {
  features {} # Used for opt-in/opt-out of AzureRM provider features.
  # 'resource_provider_registrations = "none"' is typically used only if the Terraform identity lacks permissions to register Azure Resource Providers automatically.
}

# Defines an Azure Resource Group.
# Resource Groups are logical containers for related Azure resources.
resource "azurerm_resource_group" "terraform-test-rg" {
  name     = "terraform-test-resources" # Name of the Resource Group.
  location = "newzealandnorth"          # Azure region for the Resource Group.
  # Tags are essential for resource organization, cost management, and policy application in production.
  tags = {
    environment = "dev"
  }
}

# Defines an Azure Virtual Network (VNet).
# A VNet provides a secure and isolated network for your Azure resources.
resource "azurerm_virtual_network" "terraform-test-vn" {
  name                = "terraform-test-network"                          # Name of the Virtual Network.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name     # Links to the Resource Group defined above.
  location            = azurerm_resource_group.terraform-test-rg.location # Matches the Resource Group's location.
  address_space       = ["10.123.0.0/16"]                                 # IP address space for the VNet.
  # Tags for consistent resource management.
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "terraform-test-subnet" {
  name                 = "terraform-test-subnet"                        # Name of the Subnet
  resource_group_name  = azurerm_resource_group.terraform-test-rg.name  # Links to the Resource Group defined above.
  virtual_network_name = azurerm_virtual_network.terraform-test-vn.name # Links to the Virtual Network defined above.
  address_prefixes     = ["10.123.1.0/24"]                              # IP address space for the subnet.
}

resource "azurerm_network_security_group" "terraform-test-sg" {
  name                = "terraform-test-sg"                               # Name of the Security Group
  location            = azurerm_resource_group.terraform-test-rg.location # Matches the Resource Group's location.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name     # Links to the Resource Group defined above.
  # Tags for consistent resource management.
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "terraform-test-dev-rule" {
  name                        = "terraform-test-dev-rule"                             # Name of the Security Rule. This should be unique within the Network Security Group.
  priority                    = 100                                                   # Priority of the rule. Lower numbers have higher priority. Rules are processed in order of priority.
  direction                   = "Inbound"                                             # Direction of the traffic the rule applies to. Can be "Inbound" or "Outbound".
  access                      = "Allow"                                               # Whether to "Allow" or "Deny" the traffic.
  protocol                    = "*"                                                   # The network protocol this rule applies to. 
  source_port_range           = "*"                                                   # The source port or range of ports. 
  destination_port_range      = "*"                                                   # The destination port or range of ports. 
  source_address_prefix       = "*"                                                   # The source IP address or CIDR range.
  destination_address_prefix  = "*"                                                   # The destination IP address or CIDR range.
  resource_group_name         = azurerm_resource_group.terraform-test-rg.name         # The name of the Resource Group.
  network_security_group_name = azurerm_network_security_group.terraform-test-sg.name # The name of the Network Security Group .
}

resource "azurerm_subnet_network_security_group_association" "terraform-test-sga" {
  subnet_id                 = azurerm_subnet.terraform-test-subnet.id             # The ID of the subnet to associate the NSG with.
  network_security_group_id = azurerm_network_security_group.terraform-test-sg.id # The ID of the Network Security Group to associate with the subnet.
}

resource "azurerm_public_ip" "terraform-test-ip" {
  name                = "terraform-test-ip"                               # Name of the Public IP address.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name     # The Resource Group where the Public IP will be created.
  location            = azurerm_resource_group.terraform-test-rg.location # The Azure region for the Public IP, inherited from the Resource Group.
  allocation_method   = "Dynamic"                                         # Defines how the IP address is allocated ("Static" or "Dynamic").

  tags = {
    environment = "dev" # Tag to specify the environment.
  }
}

resource "azurerm_network_interface" "terraform-test-nic" {
  name                = "terraform-test-nic"                              # Name of the Network Interface.
  location            = azurerm_resource_group.terraform-test-rg.location # Azure region for the Network Interface.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name     # The Resource Group name.

  ip_configuration {
    name                          = "internal"                              # Name of the IP configuration.
    subnet_id                     = azurerm_subnet.terraform-test-subnet.id # The ID of the subnet this NIC will be connected to.
    private_ip_address_allocation = "Dynamic"                               # Method for allocating the private IP address ("Static" or "Dynamic").
    public_ip_address_id          = azurerm_public_ip.terraform-test-ip.id  # The ID of the Public IP address to associate with this NIC.
  }

  tags = {
    environment = "dev" # Tag to specify the environment.
  }
}

resource "azurerm_linux_virtual_machine" "terraform-test-vm" {
  name                = "terraform-test-vm"                               # Name of the Linux Virtual Machine.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name     # The Resource Group where the VM will be created.
  location            = azurerm_resource_group.terraform-test-rg.location # Azure region for the VM, inherited from the Resource Group.
  size                = "Standard_B1s"                                    # The size (SKU) of the VM, determining its CPU, RAM, and I/O capabilities.
  admin_username      = "adminuser"                                       # Username for the administrative account on the VM.
  network_interface_ids = [
    azurerm_network_interface.terraform-test-nic.id, # List of Network Interface IDs to attach to this VM.
  ]

  custom_data = filebase64("customdata.tpl") # install dependecies, configure services, create user or set up SSH keys, and running scripts  

  admin_ssh_key {
    username   = "adminuser"                             # Username for SSH access.
    public_key = file("~/.ssh/terraform_test_azure.pub") # Path to the public SSH key for authentication.
  }

  os_disk {
    caching              = "ReadWrite"    # Caching setting for the OS disk ("ReadWrite", "ReadOnly", "None").
    storage_account_type = "Standard_LRS" # Type of storage for the OS disk (e.g., "Standard_LRS", "Premium_LRS").
  }

  source_image_reference {
    publisher = "Canonical"                    # Publisher of the VM image.
    offer     = "0001-com-ubuntu-server-jammy" # Offer of the VM image.
    sku       = "22_04-lts-gen2"               # SKU of the VM image, or try "az vm image list-skus" to find.
    version   = "latest"                       # Version of the VM image to use. "latest" is common for development.
  }

  provisioner "local-exec" {
    # Executes a command on the machine where Terraform is being run (your local machine).
    command = templatefile("ssh-script-${var.host_os}.tpl", {
      # The 'templatefile' function reads a template file and interpolates variables into it.
      hostname     = self.public_ip_address,        # The public IP address of the newly created VM.
      user         = "adminuser",                   # The username for SSH access on the remote VM.
      identityfile = "~/.ssh/terraform_test_azure", # The path to the SSH private key on your local machine.
      ssh_user     = var.local_ssh_username         # Your local operating system's username.
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"] # Dynamically sets the interpreter
  }

  tags = {
    environment = "dev"
  }
}

# This block retrieves information about an existing Azure Public IP resource.
data "azurerm_public_ip" "terraform-test-ip-data" {
  name                = azurerm_public_ip.terraform-test-ip.name      # References the name of the Public IP resource.
  resource_group_name = azurerm_resource_group.terraform-test-rg.name # References the name of the Resource Group.
}

# This block defines an output value that will be displayed after 'terraform apply' completes.
output "public_ip_address" {
  # The value combines the name of the VM and the IP address obtained from the data source.
  value = "${azurerm_linux_virtual_machine.terraform-test-vm.name}: ${data.azurerm_public_ip.terraform-test-ip-data.ip_address}"
}

