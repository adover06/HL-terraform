# The cluster nodes. To add the NUCs later, just add entries to this map.
locals {
  nodes = {
    k3s-control = { vm_id = 510, cores = 2, memory = 4096, disk_gb = 25 }
    k3s-worker  = { vm_id = 511, cores = 4, memory = 12288, disk_gb = 50 }
  }
}

resource "proxmox_virtual_environment_vm" "k3s" {
  for_each = local.nodes

  name      = each.key
  node_name = var.node_name
  vm_id     = each.value.vm_id

  # Clone the template. Linked clone = instant + space-efficient on ZFS.
  clone {
    vm_id = var.template_id
    full  = false
  }

  agent {
    enabled = true # lets Terraform read the VM's IP back via qemu-guest-agent
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "tank"
    interface    = "scsi0"
    size         = each.value.disk_gb
  }

  network_device {
    bridge = "vmbr2"
  }

  # Cloud-init: DHCP + your SSH key on the default 'ubuntu' user.
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = "ubuntu"
      keys     = [trimspace(var.ssh_public_key)]
    }
  }
}

# After apply, prints each node's IP — you'll need these to SSH in + install k3s.
output "node_ips" {
  value = {
    for name, vm in proxmox_virtual_environment_vm.k3s :
    name => try(vm.ipv4_addresses[1][0], "pending — re-run `terraform refresh`")
  }
}
