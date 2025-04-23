#!/bin/bash

# Use an environment variable for the public IP
EXTERNAL_IP="${TF_VAR_external_address}"

# Fetch the number of master and worker VMs from Terraform outputs
MASTER_COUNT=$(terraform output -json master_ip_addresses | jq '. | length')
WORKER_COUNT=$(terraform output -json worker_ip_addresses | jq '. | length')

# Fetch master and worker ports
MASTER_PORTS=$(terraform output -json ssh_out_master_ports)
WORKER_PORTS=$(terraform output -json ssh_out_worker_ports)

# Define the output file path
OUTPUT_FILE="../../ansible/hosts.yaml"

# Start writing to the hosts file
cat << EOF > $OUTPUT_FILE
all:
  children:
    masters:
      hosts:
EOF

# Iterate over the number of masters and fetch ports for each
for i in $(seq 1 $MASTER_COUNT); do
  port=$(echo "$MASTER_PORTS" | jq -r --arg i "$i" '.[$i|tostring]')
  cat << EOF >> $OUTPUT_FILE
        master$i:
          ansible_host: $EXTERNAL_IP
          ansible_port: $port
EOF
done

cat << EOF >> $OUTPUT_FILE
    workers:
      hosts:
EOF

# Iterate over the number of workers and fetch ports for each
for i in $(seq 1 $WORKER_COUNT); do
  port=$(echo "$WORKER_PORTS" | jq -r --arg i "$i" '.[$i|tostring]')
  cat << EOF >> $OUTPUT_FILE
        worker$i:
          ansible_host: $EXTERNAL_IP
          ansible_port: $port
EOF
done

cat << EOF >> $OUTPUT_FILE
EOF
