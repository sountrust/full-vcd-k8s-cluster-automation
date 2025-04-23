# Root module output for DNAT master SSH ports
output "ssh_out_master_ports" {
  value = module.network.dnat_master_ssh_ports
}

# Root module output for DNAT worker SSH ports
output "ssh_out_worker_ports" {
  value = module.network.dnat_worker_ssh_ports
}

# Dynamic outputs master ip addresses on vapp_vm
output "master_ip_addresses" {
  value = module.compute.master_ip_out_addresses
}

# Dynamic outputs master hostnames on vapp_vm
output "master_vm_hostnames" {
  value = module.compute.master_vm_out_hostnames
}

# Dynamic outputs worker ip addresses on vapp_vm
output "worker_ip_addresses" {
  value = module.compute.worker_ip_out_addresses
}

# Dynamic outputs worker hostnames on vapp_vm
output "worker_vm_hostnames" {
  value = module.compute.worker_vm_out_hostnames
}
