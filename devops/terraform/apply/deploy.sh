
#!/bin/bash

terr_dir="./"
echo "Terraform directory: $terr_dir"

# Initialize and apply Terraform configuration
terraform -chdir="$terr_dir" init
terraform -chdir="$terr_dir" plan 
terraform -chdir="$terr_dir" apply -auto-approve &

wait # Wait for the background Terraform job to finish

# Prepare Ansible environment
echo "Get VMs' ports written into a hosts file"
./generate_inventory.sh
./node_resolution.sh
./kubeadm_conf.sh

# Prompt user to update firewall rule
ip_set="cluster_${CI_BRANCH}_ip_set"
echo "Please add '${ip_set}' to the 'IPV4_cluster_rules' firewall rule."
read -p "Press Enter to continue after updating the firewall rule..."

# Wait for VMs to be ready
echo "Waiting for VMs to become reachable"
sleep 120

# Change directory to ansible for playbook execution
cd ../../ansible

# Configure NFS and Kubernetes data persistence with Ansible
echo "Configuring NFS and Kubernetes data persistence"
ansible-playbook -i hosts.yaml persistence_nfs.yaml
ansible-playbook -i hosts.yaml k8s_directories_persistence.yaml

# Initialize Kubernetes cluster
echo "Initializing Kubernetes cluster"
ansible-playbook -i hosts.yaml clusterMaster_conf.yaml
ansible-playbook -i hosts.yaml local_access_kubeconfig.yaml

# Short pause to ensure master is fully ready
sleep 60

# Configure worker nodes and finalize cluster setup
ansible-playbook -i hosts.yaml clusterWorker_conf.yaml
ansible-playbook -i hosts.yaml clusterFinal_conf.yaml

sleep 60

# Create flux with Helm
echo "Create dynamic NFS volume class with Helm"
ansible-playbook -i hosts.yaml dynamic_nfs_volumeClaim.yaml

# Create flux with Helm
echo "Create flux with Helm"
ansible-playbook -i hosts.yaml flux_conf.yaml

