resource "ibm_is_instance" "z1_consul_instance" {
  depends_on = [ibm_is_security_group.consul_sg]
  count      = var.instance_count
  name       = "z1-cs${count.index + 1}"
  image      = data.ibm_is_image.consul_image.id
  profile    = var.default_instance_profile

  primary_network_interface {
    subnet          = data.ibm_is_vpc.us_east_vpc.subnets[0].id
    security_groups = [ibm_is_security_group.consul_sg.id]
  }

  resource_group = data.ibm_resource_group.default_rg.id
  tags           = ["consul", var.vpc_name, data.ibm_is_zones.regional_zones.zones[0]]

  vpc       = data.ibm_is_vpc.us_east_vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[0]
  keys      = [data.ibm_is_ssh_key.linux_key.id]
  user_data = templatefile("${path.module}/z1_installer.sh", { consul_version = var.consul_version, acl_token = var.acl_token, encrypt_key = var.encrypt_key, vpc_name = var.vpc_name, domain = var.domain, zone = data.ibm_is_zones.regional_zones.zones[0], region = var.region })
}

resource "ibm_is_public_gateway" "zone2_public_gateway" {
  name           = "z2-consul-gw"
  resource_group = data.ibm_resource_group.default_rg.id
  vpc            = data.ibm_is_vpc.us_east_vpc.id
  zone           = data.ibm_is_zones.regional_zones.zones[1]
  tags           = [data.ibm_is_zones.regional_zones.zones[1], var.vpc_name]
}

resource "ibm_is_subnet" "zone2_consul_subnet" {
  name                     = "sub1-zone2"
  resource_group           = data.ibm_resource_group.default_rg.id
  vpc                      = data.ibm_is_vpc.us_east_vpc.id
  zone                     = data.ibm_is_zones.regional_zones.zones[1]
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.zone2_public_gateway.id
}

resource "ibm_is_instance" "z2_consul_instance" {
  depends_on = [ibm_is_security_group.consul_sg]
  count      = var.instance_count
  name       = "z2-cs${count.index + 1}"
  image      = data.ibm_is_image.consul_image.id
  profile    = var.default_instance_profile

  primary_network_interface {
    subnet          = ibm_is_subnet.zone2_consul_subnet.id
    security_groups = [ibm_is_security_group.consul_sg.id]
  }

  resource_group = data.ibm_resource_group.default_rg.id
  tags           = ["consul", var.vpc_name, data.ibm_is_zones.regional_zones.zones[1]]

  vpc       = data.ibm_is_vpc.us_east_vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[1]
  keys      = [data.ibm_is_ssh_key.linux_key.id]
  user_data = templatefile("${path.module}/z2_installer.sh", { consul_version = var.consul_version, acl_token = var.acl_token, encrypt_key = var.encrypt_key, vpc_name = var.vpc_name, domain = var.domain, zone = data.ibm_is_zones.regional_zones.zones[1], region = var.region })
}