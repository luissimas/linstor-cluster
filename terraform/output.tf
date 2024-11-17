output "controller_ip" {
  value = mgc_virtual_machine_instances.controller_instance.network.public_address
}

output "satellite_ips" {
  value = [for instance in mgc_virtual_machine_instances.satellite_instance : instance.network.public_address]
}

