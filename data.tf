data "ibm_is_vpc" "us_east_vpc" {
  name = var.vpc_name
}

data "ibm_resource_group" "default_rg" {
  name = var.resource_group_name
}

data "ibm_is_image" "consul_image" {
  name = var.consul_image
}

data "ibm_is_ssh_key" "linux_key" {
  name = var.linux_ssh_key
}

data "ibm_is_zones" "regional_zones" {
  region = var.region
}

data "ibm_is_subnet" "consul_subnet" {
  identifier = data.ibm_is_vpc.us_east_vpc.subnets[0].id
}