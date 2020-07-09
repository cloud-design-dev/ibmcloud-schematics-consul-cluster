resource "ibm_is_security_group" "consul_sg" {
  resource_group = data.ibm_resource_group.default_rg.id
  vpc            = data.ibm_is_vpc.us_east_vpc.id
}

resource "ibm_is_security_group_rule" "consul_icmp" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  icmp {
    type = 8
  }
}

resource "ibm_is_security_group_rule" "consul_ssh_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  tcp {
    port_min = "22"
    port_max = "22"
  }
}

resource "ibm_is_security_group_rule" "consul_http_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  tcp {
    port_min = "8500"
    port_max = "8500"
  }
}

resource "ibm_is_security_group_rule" "consul_dns_tcp_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  tcp {
    port_min = "8600"
    port_max = "8600"
  }
}

resource "ibm_is_security_group_rule" "consul_dns_udp_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  udp {
    port_min = "8600"
    port_max = "8600"
  }
}

resource "ibm_is_security_group_rule" "consul_rpc_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  tcp {
    port_min = "8300"
    port_max = "8300"
  }
}

resource "ibm_is_security_group_rule" "consul_lan_wan_tcp_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  tcp {
    port_min = "8301"
    port_max = "8302"
  }
}

resource "ibm_is_security_group_rule" "consul_lan_wan_udp_inbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "inbound"
  remote     = data.ibm_is_vpc.us_east_vpc.subnets[0].ipv4_cidr_block
  udp {
    port_min = "8301"
    port_max = "8302"
  }
}

resource "ibm_is_security_group_rule" "outbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "tcp_dns_outbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = "53"
    port_max = "53"
  }
}

resource "ibm_is_security_group_rule" "udp_dns_outbound" {
  depends_on = [ibm_is_security_group.consul_sg]
  group      = ibm_is_security_group.consul_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
  udp {
    port_min = "53"
    port_max = "53"
  }
}