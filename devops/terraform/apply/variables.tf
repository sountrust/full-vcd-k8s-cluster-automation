variable "vcd_token" {
  type = string
  sensitive = true
}

variable "vcd_org" {
  type = string
  sensitive = true
}

variable "vcd_url" {
  type = string
  sensitive = true
}

variable "vcd_vdc_group" {
  type = string
  sensitive = true
}

variable "vcd_vdc" {
  type = string
  sensitive = true
}

variable "vcd_nsxt_edgegateway" {
  type = string
  sensitive = true
}

variable "environment" {
  description = "cluster's environment depending on the branch name"
  type        = string
}

variable "vcd_catalog_name" {
  description = "The name of the vCD catalog"
  type        = string
}

variable "vcd_vapp_template_name" {
  description = "The name of the vApp template in the vCD catalog"
  type        = string
}

variable "worker_vm_count" {
  description = "Number of workers in the cluster"
  type        = string
}

variable "master_vm_count" {
  description = "Number of masters in the cluster"
  type        = string
}

variable "sizing_master_name" {
  description = "Sizing masters vms from fixed values"
  type        = string
}

variable "sizing_worker_name" {
  description = "Sizing workers vms from fixed values"
  type        = string
}

variable "master_data_disk_size" {
  description = "Master data disk size definition"
  type        = string
}

variable "master_fs_disk_size" {
  description = "Master fs disk size definition"
  type        = string
}

variable "worker_data_disk_size" {
  description = "Worker data disk size definition"
  type        = string
}

#variable "worker_fs_disk_size" {
#  description = "Worker fs disk size definition"
#  type        = string
#}

variable "env_subnet" {
  description = "Subnetwork related to the deployment environment"
  type        = string
}

variable "external_address" {
  description = "Public IP address related to deployment environment"
  type = string
}

variable "ssh_port" {
  description = "SSH port related to the deployment environment"
  type = number
}

variable "kubectl_port" {
  description = "kubectl port related to the deployment environment"
  type = number
}

variable "http_port" {
  description = "http port related to the deployment environment"
  type = number
}

variable "https_port" {
  description = "https port related to the deployment environment"
  type = number
}

variable "dns_servers" {
  description = "VCD DNS server address"
  type = list(string)
}

variable "k8s_api_domain" {
  description = "The domain part for the Kubernetes API server"
  type        = string
}
