variable "resource_group_name" {
  default = "devTFResourceGroup"
}

variable "location_name" {
  default = "eastus"
}

variable "address_space_name" {
  default = ["10.0.0.0/16"]
}

variable "host_os" {
  type    = string
  default = "linux"

}

variable "azure_vm_size" {
  type        = string
  description = "state vm capacity"
  default     = "Standard_B1s"
}

variable "azure_vm_name" {
  type    = string
  default = "devTF-virtual-machine"
}

variable "virtual_network_name" {
  type    = string
  default = "devTFVnet"
}

variable "subnet_id" {
  type    = string
  default = "devTF-pub-subnet"
}