resource "ibm_is_instance" "consul_instance" {
  count   = var.instance_count
  name    = "consul-server${count.index + 1}"
  image   = data.ibm_is_image.consul_image.id
  profile = var.default_instance_profile

  primary_network_interface {
    subnet = data.ibm_is_vpc.us_east_vpc.subnets[0].id
  }

  resource_group = data.ibm_resource_group.default_rg.id
  tags           = ["consul", var.vpc_name, data.ibm_is_zones.regional_zones.zones[0]]

  vpc       = data.ibm_is_vpc.us_east_vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[0]
  keys      = [data.ibm_is_ssh_key.linux_key.id]
  user_data = templatefile("${path.module}/installer.sh", { consul_version = var.consul_version, acl_token = var.acl_token, encrypt_key = var.encrypt_key, vpc_name = var.vpc_name, zone = data.ibm_is_zones.regional_zones.zones[0], region = var.region })
}


resource "ibm_dns_resource_record" "consul_server_dns" {
  depends_on  = [ibm_is_instance.consul_instance]
  count       = var.instance_count
  instance_id = var.dns_instance_id
  zone_id     = var.zone_id
  type        = "A"
  name        = "consul-server${count.index + 1}"
  rdata       = element(ibm_is_instance.consul_instance[*].primary_network_interface[0].primary_ipv4_address, count.index)
}

