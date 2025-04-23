module "compute" {
  source = "../modules/computes"
  environment_network = var.env_subnet
  env_deployment = var.environment
  worker_count = var.worker_vm_count
  master_count = var.master_vm_count
  sizing_master_key = var.sizing_master_name
  sizing_worker_key = var.sizing_worker_name
  dmaster_data_size = var.master_data_disk_size
  dmaster_fs_size = var.master_fs_disk_size
  dworker_data_size = var.worker_data_disk_size
  #  dworker_fs_size = var.worker_fs_disk_size
  vapp_network_name = module.network.vapp_net_out_name
  vapp_template_id = module.catalog.vapp_template_out_id
  dns_servers = var.dns_servers
  k8s_api_domain = var.k8s_api_domain
}

