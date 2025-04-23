#!/bin/bash

# Retrieve the number of master and worker VMs as integers
MASTER_COUNT=$(echo "${TF_VAR_master_vm_count}" | bc)
WORKER_COUNT=$(echo "${TF_VAR_worker_vm_count}" | bc)

# Paths to the output files
CLUSTER_IPS_FILE="../../k8s/tmp/cluster_ips.yaml"
CLUSTER_HOSTNAMES_FILE="../../k8s/tmp/cluster_hostnames.yaml"

# Clear or create files
> "$CLUSTER_IPS_FILE"
> "$CLUSTER_HOSTNAMES_FILE"

# Fetch and format IP addresses and hostnames for masters
for i in $(seq 1 $MASTER_COUNT); do
    ip=$(terraform output -json master_ip_addresses | jq -r ".[$((i-1))]")
    hostname=$(terraform output -json master_vm_hostnames | jq -r ".[$((i-1))]")
    echo "master$i: $ip" >> "$CLUSTER_IPS_FILE"
    echo "master$i: $hostname" >> "$CLUSTER_HOSTNAMES_FILE"
done

# Fetch and format IP addresses and hostnames for workers
for i in $(seq 1 $WORKER_COUNT); do
    ip=$(terraform output -json worker_ip_addresses | jq -r ".[$((i-1))]")
    hostname=$(terraform output -json worker_vm_hostnames | jq -r ".[$((i-1))]")
    echo "worker$i: $ip" >> "$CLUSTER_IPS_FILE"
    echo "worker$i: $hostname" >> "$CLUSTER_HOSTNAMES_FILE"
done

echo "IP addresses and hostnames for masters and workers have been written to respective YAML files."
