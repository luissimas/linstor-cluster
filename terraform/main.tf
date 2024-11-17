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
