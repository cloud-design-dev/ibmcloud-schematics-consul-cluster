data "ibm_is_vpc" "us_east_vpc" {
  name = var.vpc_name
}

data "ibm_resource_group" "cde_rg" {
  name = var.resource_group_name
}

data "ibm_is_ssh_key" "us_east_key" {
  name = var.ssh_key
}

data "ibm_is_image" "consul_image" {
  name = var.consul_image

}

data "ibm_is_image" "windows_image" {
  name = var.windows_image
}