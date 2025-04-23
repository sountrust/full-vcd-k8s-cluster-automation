# Calling network environment, creation and configuration
module "network" {
  source = "../modules/networks"
  environment_network = var.env_subnet
  env_deployment = var.environment
  vapp_name = module.compute.vapp_out_name 
  public_ip = var.external_address
  master_ip_addresses = module.compute.master_ip_out_addresses 
  worker_ip_addresses = module.compute.worker_ip_out_addresses 
  master_hostnames = module.compute.master_vm_out_hostnames
  worker_hostnames = module.compute.worker_vm_out_hostnames 
  edge_id = data.vcd_nsxt_edgegateway.existing.id
  edge_name = data.vcd_nsxt_edgegateway.existing.name
  vdc_group_id = data.vcd_vdc_group.main.id
  env_ssh_port = var.ssh_port
  env_kubectl_port = var.kubectl_port
  env_http_port = var.http_port
  env_https_port = var.https_port
  dns_servers = var.dns_servers
}

