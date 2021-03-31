variable "environment" {
  type    = string
  default = "dev"
}

variable "main_name" {
  type    = string
  default = "muzi"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "subnet-list" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

locals {
  rg-name   = "${var.main_name}-rg-${var.environment}"
  vnet-name = "${var.main_name}-vnet-${var.environment}"
  sn-name   = "${var.main_name}-sn-${var.environment}"
  nsg-name  = "${var.main_name}-nsg-${var.environment}"

  dns-prefix = "${var.main_name}-${var.environment}"

  computer_name  = "${var.main_name}-vm"
  admin_username = "${var.main_name}-user"
  admin_password = "${var.main_name}P@ss123"
}