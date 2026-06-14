variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, e.g. https://<R230-ip>:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token: user@realm!tokenid=secret"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Your SSH public key (contents of ~/.ssh/id_ed25519.pub) injected into the VMs"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "template_id" {
  description = "VMID of the Ubuntu cloud-init template to clone"
  type        = number
  default     = 500
}
