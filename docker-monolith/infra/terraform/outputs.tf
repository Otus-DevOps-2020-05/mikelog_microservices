
output "external_ip_address_app" {

  value = yandex_compute_instance.docker-host.*.network_interface.0.nat_ip_address
}

output "lb_ip_addr" {
  value = yandex_lb_network_load_balancer.docker-host-lb.listener.*.external_address_spec.0.address
}
