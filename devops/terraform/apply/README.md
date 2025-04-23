# Terraform Root Module

This directory defines the root module for provisioning a Kubernetes cluster infrastructure using VMware vCloud Director (vCD) with Terraform. It orchestrates multiple reusable submodules—`catalogs`, `computes`, and `networks`—as well as several bash scripts for post-deployment automation.

---

## 🌐 Overview

The project is structured to deploy three distinct Kubernetes environments—`dev`, `pre-prod`, and `prod`—based on the active Git branch. Each environment has:

- Unique network subnets
- Distinct firewall rules
- Differentiated VM sizing and disk allocation

The root module bootstraps the infrastructure and integrates tightly with Ansible for complete post-provisioning.

---

## 📁 Module Structure

### ➤ `catalog`
Fetches a vApp template from a vCD catalog.

- Inputs:
  - `catalog_name`
  - `vapp_template_name`
- Output:
  - `vapp_template_out_id`

### ➤ `compute`
Provisions master and worker VMs using the vApp template, sizing policies, and network settings.

- Inputs:
  - Environment variables passed from the root module
  - Template ID from `catalog`
  - Network output from `network`
- Outputs:
  - VApp name
  - Master/worker IPs and hostnames

### ➤ `network`
Configures networking, load balancer, NAT rules, and exposes the cluster publicly.

- Inputs:
  - Edge Gateway info (looked up via data sources)
  - IP addresses and hostnames from `compute`
  - Public IP and port assignments

---

## ⚙️ Bash Scripts

The root module includes helper scripts that coordinate with Terraform and Ansible:

### 🔹 `deploy.sh`
Main entrypoint. Automates:

- Terraform `init`, `plan`, `apply`
- Inventory generation
- Kubeadm config generation
- Hostname/IP extraction
- NFS/K8s setup via Ansible

### 🔹 `generate_inventory.sh`
Dynamically creates the `hosts.yaml` inventory for Ansible.

- Uses Terraform outputs to resolve IPs and SSH ports
- Categorizes into `masters` and `workers`
- Targets dynamic IP mapping to external address

### 🔹 `node_resolution.sh`
Generates cluster metadata for Ansible:

- Creates `cluster_ips.yaml` and `cluster_hostnames.yaml`
- Used by Ansible playbooks for NFS sync and identity

### 🔹 `kubeadm_conf.sh`
Generates the kubeadm config dynamically for initializing the Kubernetes cluster:

- Applies correct `controlPlaneEndpoint`
- Substitutes dynamic public IP and DNS name
- Includes CNI configuration and containerd storage mounts

---

## 🌍 Branch-Based Environments

The Git branch name (`dev`, `pre-prod`, `prod`) drives the entire infrastructure profile:

| Branch     | Cluster Size | Subnet         | API Port | Sizing Profile |
|------------|---------------|----------------|----------|----------------|
| `dev`      | Small         | 192.168.42.0/24 | 5443     | `small`        |
| `pre-prod` | Medium        | 192.168.43.0/24 | 5443     | `xlarge`       |
| `prod`     | Full-scale    | 192.168.44.0/24 | 6443     | `2xlarge+`     |

These variables are auto-injected using `TF_VAR_` prefixed environment variables.

---

## 🔐 Environment Variables

The following environment variables should be exported before running `deploy.sh`:

### General Configuration
```bash
export TF_VAR_environment=dev
export TF_VAR_env_subnet=192.168.42
export TF_VAR_external_address=1.2.3.4
export TF_VAR_dns_servers='["8.8.8.8", "8.8.4.4"]'
export TF_VAR_k8s_api_domain=k8s.dev.mycompany.com
```

### VM Configuration
```bash
export TF_VAR_worker_vm_count=2
export TF_VAR_master_vm_count=1
export TF_VAR_sizing_master_name=l
export TF_VAR_sizing_worker_name=l
export TF_VAR_master_data_disk_size=51200
export TF_VAR_master_fs_disk_size=20480
export TF_VAR_worker_data_disk_size=51200
```

### Networking Ports
```bash
export TF_VAR_ssh_port=5022
export TF_VAR_kubectl_port=5443
export TF_VAR_http_port=3080
export TF_VAR_https_port=3443
```

### vCD Configuration
```bash
export TF_VAR_vcd_token=your_token
export TF_VAR_vcd_org=your_org
export TF_VAR_vcd_url=https://vcd.example.com
export TF_VAR_vcd_vdc_group=group_name
export TF_VAR_vcd_vdc=your_vdc
export TF_VAR_vcd_nsxt_edgegateway=edge_name
export TF_VAR_vcd_catalog_name=mycatalog
export TF_VAR_vcd_vapp_template_name=k8s-template
```

---

## ✅ Deployment Flow

1. Configure your environment variables
2. Run `./deploy.sh`
3. Wait for Terraform to complete
4. Ansible will provision the cluster, copy kubeconfig, install Helm, Flux, NFS

---

## 📌 Notes

- Firewall configuration still requires manual input for IP allowlisting
- The deployment is **idempotent** and modular for production use

---

## 📁 Outputs

| Output Name           | Description                      |
|-----------------------|----------------------------------|
| `ssh_out_master_ports` | SSH ports for master nodes       |
| `ssh_out_worker_ports` | SSH ports for worker nodes       |
| `master_ip_addresses`  | IPs of master VMs                |
| `worker_ip_addresses`  | IPs of worker VMs                |
| `master_vm_hostnames`  | Hostnames of master VMs          |
| `worker_vm_hostnames`  | Hostnames of worker VMs          |

