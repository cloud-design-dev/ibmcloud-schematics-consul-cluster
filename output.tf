output "lb_fqdn" {
  value = ibm_is_lb.public_consul_instance_lb.hostname
}
