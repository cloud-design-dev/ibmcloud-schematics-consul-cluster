resource "ibm_is_lb" "consul_instance_lb" {
  depends_on     = [ibm_is_instance.consul_instance]
  name           = "consul-lb"
  subnets        = [data.ibm_is_vpc.us_east_vpc.subnets[0].id]
  resource_group = data.ibm_resource_group.default_rg.id
  type           = "public"
  tags           = [var.vpc_name, "consul"]
}


resource "ibm_is_lb_listener" "consul_instance_listener" {
  lb         = ibm_is_lb.consul_instance_lb.id
  port       = "80"
  protocol   = "tcp"
  depends_on = [ibm_is_lb.consul_instance_lb]
}

resource "ibm_is_lb_pool" "consul_instance_pool" {
  lb                 = ibm_is_lb.consul_instance_lb.id
  name               = "coinsul-pool"
  protocol           = "tcp"
  algorithm          = "round_robin"
  health_delay       = "5"
  health_retries     = "2"
  health_timeout     = "2"
  health_type        = "tcp"
  health_monitor_url = "/"
  depends_on         = [ibm_is_lb_listener.consul_instance_listener]
}

resource "ibm_is_lb_pool_member" "private_instance_pool_member_zone" {
  count          = var.instance_count
  lb             = ibm_is_lb.consul_instance_lb.id
  pool           = ibm_is_lb_pool.consul_instance_pool.id
  port           = "8500"
  target_address = element(ibm_is_instance.consul_instance[*].primary_network_interface[0].primary_ipv4_address, count.index)
  depends_on     = [ibm_is_lb_pool.consul_instance_pool]
}