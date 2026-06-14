terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

# Connection + auth to your Proxmox host. Real values live in terraform.tfvars.
provider "proxmox" {
  endpoint  = var.proxmox_endpoint   # e.g. https://192.168.x.x:8006/
  api_token = var.proxmox_api_token  # root@pam!terraform=<secret>
  insecure  = true                   # Proxmox ships a self-signed cert
}
