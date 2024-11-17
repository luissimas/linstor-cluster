locals {
  satellite_indexes = toset([for i in range(1, var.satellite_count + 1) : tostring(i)])
}

resource "mgc_ssh_keys" "ssh_key" {
  name = "terraform key"
  key  = file(var.public_key)
}

resource "mgc_virtual_machine_instances" "controller_instance" {
  name = "controller"
  machine_type = {
    name = "BV1-2-10"
  }
  image = {
    name = "cloud-ubuntu-24.04 LTS"
  }
  network = {
    associate_public_ip = true
    interface = {
      security_groups = [{ id = mgc_network_security_groups.controller.id }]
    }
  }
  ssh_key_name = mgc_ssh_keys.ssh_key.name
}

resource "mgc_virtual_machine_instances" "satellite_instance" {
  for_each = local.satellite_indexes
  name     = "satellite-${each.value}"
  machine_type = {
    name = "BV1-2-10"
  }
  image = {
    name = "cloud-ubuntu-24.04 LTS"
  }
  network = {
    associate_public_ip = true
  }
  ssh_key_name = mgc_ssh_keys.ssh_key.name
}

resource "mgc_block_storage_volumes" "satellite_volume" {
  for_each = local.satellite_indexes
  name     = "satellite-volume-${each.value}"
  size     = var.satellite_volume_size
  type = {
    name = "cloud_nvme1k"
  }
}

resource "mgc_block_storage_volume_attachment" "satellite_volumes" {
  for_each           = local.satellite_indexes
  block_storage_id   = mgc_block_storage_volumes.satellite_volume[each.value].id
  virtual_machine_id = mgc_virtual_machine_instances.satellite_instance[each.value].id
}

resource "mgc_network_security_groups" "controller" {
  name                  = "controller"
  description           = "Security group for Linstor controller instances"
  disable_default_rules = false
}

resource "mgc_network_security_groups_rules" "allow_ssh" {
  description       = "Allow incoming SSH traffic"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.controller.id
}

resource "mgc_network_security_groups_rules" "allow_3370" {
  description       = "Allow incoming TCP traffic on port 3370"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 3370
  port_range_max    = 3370
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.controller.id
}
