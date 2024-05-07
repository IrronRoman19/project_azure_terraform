variable "rg_name" {
    description = "The name of the resource group"
    type = string
}

variable "rg_location" {
    description = "The location of the resource group"
    type = string
}

variable "vnet_name" {
    description = "The name of the virtual network"
    type = string
}

variable "vnet_address_space" {
    description = "The address space of the virtual network"
    type = string
}

variable "sb_name_1" {
    description = "The name of the 1st subnet"
    type = string
}

variable "sb_name_2" {
    description = "The name of the 2nd subnet"
    type = string
}

variable "sb_1_address_prefix" {
    description = "The address space of the 1st subnet"
    type = string
}

variable "sb_2_address_prefix" {
    description = "The address space of the 2nd subnet"
    type = string
}

variable "nic_name_1" {
    description = "The name of the 1st network interface"
    type = string
}

variable "nic_name_2" {
    description = "The name of the 2nd network interface"
    type = string
}

variable "ip_address_1" {
    description = "The private IP address of the 1st network interface"
    type = string
}

variable "ip_address_2" {
    description = "The private IP address of the 2nd network interface"
    type = string
}

variable "ipconfig_name_1" {
    description = "The name of the 1st IP configuration"
    type = string
}

variable "ipconfig_name_2" {
    description = "The name of the 2nd IP configuration"
    type = string
}

variable "pip_vm_1" {
    description = "The public IP for 1st virtual machine"
    type = string
}

variable "nsg_name_1" {
    description = "The name for 1st network security group"
    type = string
}

variable "nsg_name_2" {
    description = "The name for 2nd network security group"
    type = string
}

variable "nsg_rule_name_1" {
    description = "The name for 1st network security group rule"
    type = string
}

variable "nsg_rule_name_2_1" {
    description = "The name for 2nd network security group 1st rule"
    type = string
}

variable "nsg_rule_name_2_2" {
    description = "The name for 2nd network security group 2nd rule"
    type = string
}

variable "nsg_dest_port_range_1" {
    description = "The destination port range for 1st network security group rule"
    type = string
}

variable "nsg_dest_port_range_2_1" {
    description = "The destination port range for 2nd network security group 1st rule"
    type = string
}

variable "nsg_dest_port_range_2_2" {
    description = "The destination port range for 2nd network security group 2nd rule"
    type = string
}

variable "nsg_priority_1" {
    description = "The 1st priority of network security group"
    type = string
}

variable "nsg_priority_2" {
    description = "The 1st priority of network security group"
    type = string
}

variable "vm_name_1" {
    description = "The name of the 1st virtual machine"
    type = string
}

variable "vm_name_2" {
    description = "The name of the 2nd virtual machine"
    type = string
}

variable "your_public_ip" {
    description = "The your computer public IP address"
}

variable "vm_username" {
    description = "The username of the virtual machines"
    type = string
}

variable "vm_password" {
    description = "The password of the virtual machines"
    type = string
}

variable "postgresql_db_name" {
    description = "The name of the postgres database"
    type = string
}

variable "postgresql_table_name" {
    description = "The name of the postgres table"
    type = string
}

variable "postgresql_name_value_1" {
    description = "The 1st value of the name in postgres table"
    type = string
}

variable "postgresql_name_value_2" {
    description = "The 2nd value of the name in postgres table"
    type = string
}

variable "postgresql_name_value_3" {
    description = "The 3rd value of the name in postgres table"
    type = string
}

variable "postgresql_number_value_1" {
    description = "The 1st value of the number in postgres table"
    type = string
}

variable "postgresql_number_value_2" {
    description = "The 2nd value of the number in postgres table"
    type = string
}

variable "postgresql_number_value_3" {
    description = "The 3rd value of the number in postgres table"
    type = string
}

variable "postgresql_username" {
    description = "The username of the PostgreSQL"
    type = string
}

variable "postgresql_password" {
    description = "The password of the PostgreSQL"
    type = string
}