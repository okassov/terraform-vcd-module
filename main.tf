# Configure the VMware Cloud Director Provider

provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  auth_type            = "integrated"
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}


resource "vcd_independent_disk" "dataDisk" {
  count = var.data_disk != null ? length(var.virtual_machines) : 0
  vdc             = var.vcd_vdc
  name            = "${keys(var.data_disk)[0]}-${keys(var.virtual_machines)[count.index]}"
  size_in_mb      = values(var.data_disk)[0]["size"]
  bus_type        = values(var.data_disk)[0]["bus_type"]
  bus_sub_type    = values(var.data_disk)[0]["bus_sub_type"]
  storage_profile = values(var.data_disk)[0]["profile"]
}


resource "vcd_vapp_vm" "marik-test" {

  for_each = var.virtual_machines

  vapp_name              = each.value.vapp
  name                   = each.key
  catalog_name           = var.vcd_catalog_name
  template_name          = var.vcd_template_name
  memory                 = each.value.memory
  cpus                   = each.value.cpu
  cpu_hot_add_enabled    = true
  memory_hot_add_enabled = true

  metadata = {
    env     = var.env
    project = var.project
    role    = var.role
  }

  guest_properties = {
    "guest.hostname" = "localhost"
    "guest.other"    = "another-setting"
  }

  dynamic "network" {
    for_each = each.value.additional_networks != null ? each.value.additional_networks : {}

    content {
      name = network.key
      type = network.value.type
      ip_allocation_mode = network.value.ip_allocation_mode
      ip = network.value.ip
    }
  }

  network {
    type               = each.value.network_type
    name               = each.value.network
    ip_allocation_mode = each.value.ip_allocation_mode
    ip                 = each.value.ip
    is_primary         = true
    connected          = true
  }

  dynamic "disk" {

    for_each = vcd_independent_disk.dataDisk

    content {
      name = "${keys(var.data_disk)[0]}-${each.key}"
      bus_number  = 0
      unit_number = 1
    }
  }

  depends_on = [
    vcd_independent_disk.dataDisk
  ]

  customization {
    enabled    = true
    force      = false
    initscript = <<EOT
  #!/bin/bash
  sudo cat<<EOF > /etc/netplan/00-installer-config.yaml
  network:
    version: 2
    renderer: networkd
    ethernets:
      $(ip add | grep 2: | awk '{print$2}' | tr -d ':'):
        dhcp4: false
        addresses:
          - ${each.value.ip}/${each.value.netmask}
        gateway4: ${each.value.gateway}
        nameservers:
          addresses:
            - ${each.value.dns}
  EOF
  sudo netplan apply
  EOT
  }

}
