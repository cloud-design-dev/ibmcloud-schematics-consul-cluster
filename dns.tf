resource "ibm_dns_resource_record" "consul_server_dns_zone1" {
  depends_on  = [ibm_is_instance.z1_consul_instance]
  count       = var.instance_count
  instance_id = var.dns_instance_id
  zone_id     = var.zone_id
  type        = "A"
  name        = "z1-cs${count.index + 1}"
  rdata       = element(ibm_is_instance.z1_consul_instance[*].primary_network_interface[0].primary_ipv4_address, count.index)
}

resource "ibm_dns_resource_record" "consul_server_dns_zone2" {
  depends_on  = [ibm_is_instance.z2_consul_instance]
  count       = var.instance_count
  instance_id = var.dns_instance_id
  zone_id     = var.zone_id
  type        = "A"
  name        = "z2-cs${count.index + 1}"
  rdata       = element(ibm_is_instance.z2_consul_instance[*].primary_network_interface[0].primary_ipv4_address, count.index)
}