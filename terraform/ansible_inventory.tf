resource "ansible_group" "controller" {
  name = "controllers"
}

resource "ansible_group" "satellite" {
  name = "satellites"
}

resource "ansible_host" "controller" {
  name   = "controller"
  groups = ["controllers"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = mgc_virtual_machine_instances.controller_instance.network.public_address
  }
}

resource "ansible_host" "satellite" {
  for_each = mgc_virtual_machine_instances.satellite_instance
  name     = "satellite-${each.key}"
  groups   = ["satellites"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = each.value.network.public_address
  }
}
