# ¿¿ VCloudDirector ¿ Complete Infrastructure as Code (IaC) Stack

This repository offers a comprehensive and modular Infrastructure as Code (IaC) solution for provisioning, bootstrapping, configuring, and operating Kubernetes clusters tailored for a multi-environment marketplace platform. It is designed to be reproducible, environment-driven (dev/pre-prod/prod), and maintainable via GitOps workflows.

---

## ¿ Submodules Overview

This monorepo is composed of several Git submodules that separate concerns and support reusability and templating flexibility:

| Submodule           | Path                                 | Description                                                                 |
|---------------------|--------------------------------------|-----------------------------------------------------------------------------|
| `terraform-modules` | `devops/terraform/modules`           | Core reusable Terraform logic for vCD: compute, network, and catalog setup |
| `ansible`           | `devops/ansible`                     | Post-Terraform configuration of VMs and cluster (e.g. NFS, kubeadm, Helm)  |
| `k8s`               | `devops/k8s`                         | Kubernetes native resources and GitOps with Flux                           |
| `kube-deploy`       | `devops/k8s/kube-deploy`             | Auto-deployment builder and app manifest generator for customers           |
| `templating`        | `templating/`                        | Prior step to provision reusable base VMs via Terraform and Ansible        |
| `cataloging`        | `templating/terraform/cataloging`    | Git submodule to manage Ubuntu image uploads to vCD catalogs               |
| `networking`        | `templating/terraform/networking`    | Git submodule to define NSXT edge rules (NAT, FW, IP sets) for networks    |

---

## ¿ Architecture Highlights

- **Cloud Provider**: vCloud Director (vCD)
- **Cluster Provisioning**: Terraform + Ansible
- **Bootstrap & GitOps**: FluxCD
- **App Deployment & Lifecycle**: appManager + custom CI pipeline + `kube-deploy`
- **Multi-tenant / Environment-aware**: Each Git branch = one cluster config (dev, pre-prod, prod)
- **CI**: Internal GitLab + GitHub integration (for remote bootstrap without exposing GitLab)

---

## ¿ Folder Structure

```bash
monacocloud/
¿¿¿ devops/
¿   ¿¿¿ terraform/              # Main Terraform execution
¿   ¿¿¿ terraform/modules/      # Git submodule with reusable TF logic
¿   ¿¿¿ ansible/                # Git submodule for post-TF configuration
¿   ¿¿¿ k8s/                    # Git submodule for GitOps and platform services
¿       ¿¿¿ kube-deploy/        # Sub-submodule used by appManager for auto-deployment
¿¿¿ templating/                 # Git submodule for provisioning base reusable VMs
¿   ¿¿¿ terraform/
¿   ¿   ¿¿¿ template/           # Root module that wires everything together
¿   ¿   ¿¿¿ modules/            # Local TF modules
¿   ¿   ¿¿¿ cataloging/         # Git submodule to push base Ubuntu templates to catalog
¿   ¿   ¿¿¿ networking/         # Git submodule for NSXT edge NAT + firewall rules
¿   ¿¿¿ ansible/                # Plays used after Terraform to prepare VMs for templating
¿¿¿ *.xlsx                      # Architecture diagrams, cost estimates, etc.
```

---

## ¿ GitOps Flow

1. **Templating (Optional but Recommended)**:
   - Run `templating/terraform/template/` to build reusable VM templates
   - Manually capture them in `cataloging` to vCD catalogs

2. **Terraform (Main Apply)**:
   - Provisions all vCD resources (VApps, VMs, NATs, Disks, etc.)

3. **Ansible**:
   - Configures hosts (NFS, kubeadm, Helm, networking, local kubeconfig access)

4. **Flux (GitOps)**:
   - Syncs `k8s/flux` and `infra-deploy/*` from GitHub or GitLab

5. **appManager**:
   - Listens to marketplace events, triggers auto-deploys (via `kube-deploy`)

6. **Flux (Apps)**:
   - Applies generated manifests automatically

---

## ¿ Environment Strategy

- **Branch-Aware Deployments**:
  - `dev`, `pre-prod`, and `prod` are mapped to cluster configurations
  - Each branch has its own IP pool, catalog, and secrets

- **Secrets Management**:
  - Kubernetes Secrets via `app-secrets`
  - Mail, DNS, Cassandra, Git, and MemberPress credentials are injected securely

---

## ¿ CI/CD & Automation

- **Jenkins**: For internal testing, packaging, and optional scheduled Terraform plans
- **GitLab**: Infrastructure and sensitive resources are managed here
- **GitHub**: Application layer GitOps bootstrapping with Flux; no internal exposure needed

---

## ¿¿ Getting Started

1. Clone with submodules:
   ```bash
   git clone --recurse-submodules <repo-url>
   ```

2. Export environment-specific variables:
   ```bash
   export TF_VAR_environment=dev
   export TF_VAR_env_subnet=192.168.42
   # ... others for vCD auth, ports, domains, etc.
   ```

3. Deploy infrastructure:
   ```bash
   cd devops/terraform/apply
   ./deploy.sh
   ```

4. Let Flux take over:
   - Monitor the cluster bootstrap logs
   - Visit apps or dashboards provisioned by `kube-deploy` or FluxCD

---

## ¿ Documentation

Each submodule contains its own `README.md`:

- [Terraform Modules](https://github.com/sountrust/terraform-vcd-k8s-modules)
- [Ansible Config](https://github.com/sountrust/ansible_k8s_ready)
- [Kubernetes & Flux Setup](https://github.com/sountrust/k8s)
- [App Deploy & Auto-Provisioning](https://github.com/sountrust/app-deploy.git)
- [Templating Repo](https://github.com/sountrust/templating)
  - [Cataloging](https://github.com/sountrust/cataloging)
  - [Networking](https://github.com/sountrust/networking)

---

## ¿ Cleanup

To destroy all infrastructure:
```bash
cd devops/terraform/apply
terraform destroy
```

To uninstall GitOps stack (Flux):
```bash
flux uninstall
```

---

## ¿ Contact

Maintained by [Sountrust DevOps Team](mailto:paul@sountrust.com)
