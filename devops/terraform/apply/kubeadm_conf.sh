#!/bin/bash

# Use an environment variable for the public IP
EXTERNAL_IP="${TF_VAR_external_address}"

# Use an environment variable for the CNI podsubnet
POD_SUBNET="${K8S_CNI_SUBNET}"

# Use an environment variable for the cluster subnet
ENV_SUBNET="${TF_VAR_env_subnet}"

# Use an environment variable for the kubernetes api internal endpoint
K8S_API_DOMAIN="${TF_VAR_k8s_api_domain}"

# Define file paths
KUBEADM_CONFIG_FILE="../../k8s/tmp/kubeadm-config.yaml"

# Generate or Update kubeadm-config.yaml with the dynamic controlPlaneEndpoint
cat <<EOF > "$KUBEADM_CONFIG_FILE"
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: "1.29.1"
controlPlaneEndpoint: "${K8S_API_DOMAIN}"
networking:
  podSubnet: "${POD_SUBNET}"
apiServer:
  extraArgs:
    api-audiences: "api"
    service-account-issuer: "kubernetes.default.svc"
    service-account-signing-key-file: "/etc/kubernetes/pki/sa.key"
    service-account-key-file: "/etc/kubernetes/pki/sa.pub"
    authorization-mode: "Node,RBAC"
  certSANs:
    - "${EXTERNAL_IP}"
    - "${K8S_API_DOMAIN}"
    - "${ENV_SUBNET}.102"
etcd:
  local:
    dataDir: "/mnt/k8s_data/etcd"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    root-dir: "/mnt/k8s_data/kubelet"  # Your mounted external storage path for kubelet
    pod-infra-container-image: "k8s.gcr.io/pause:3.9"
    cgroup-driver: "systemd"
EOF

echo "kubeadm-config.yaml generated/updated with dynamic IP and hostnames"
