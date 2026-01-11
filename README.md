# DevOps Project Skeleton

A boilerplate/skeleton repository for bootstrapping new AWS accounts and DevOps projects with Infrastructure-as-Code best practices.

**Tech Stack:** Terraform | Ansible | Kubernetes (K3s) | SOPS | AWS

## Overview

This skeleton provides a standardized structure for:

- **AWS Infrastructure** - VPCs, IAM users/groups, networking via Terraform
- **Configuration Management** - Server provisioning and configuration via Ansible
- **Container Orchestration** - Kubernetes manifests for K3s clusters
- **Secrets Management** - Encrypted secrets using SOPS with PGP

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 0.12
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.9
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [SOPS](https://github.com/mozilla/sops)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- [GPG](https://gnupg.org/) for SOPS encryption
- [Terraform Cloud](https://app.terraform.io/) account (for remote state)

## Directory Structure

```
.
├── terraform/                    # Infrastructure as Code
│   ├── environments/             # Per-environment configurations
│   │   └── env-test1/
│   │       ├── global/           # IAM users, groups, account resources
│   │       └── networks/         # VPCs, subnets, routing
│   └── modules/                  # Reusable Terraform modules
│       └── iam/
│
├── ansible/                      # Configuration Management
│   ├── ansible.cfg               # Ansible settings
│   └── inventories/              # Dynamic inventory scripts
│       └── env-name.region/
│           └── group_vars/       # Group-specific variables
│
├── kubernetes/                   # Container Orchestration
│   └── clusters/
│       └── k3s-local/            # K3s cluster manifests
│           ├── ingress/          # Traefik ingress rules
│           └── namespaces/       # Namespace definitions
│
├── configs/                      # Configuration Files
│   ├── environments/             # Environment definitions (YAML)
│   ├── secrets/                  # SOPS-encrypted secrets
│   └── users/                    # SSH public keys
│
└── .sops.yaml                    # SOPS encryption configuration
```

## Getting Started

### 1. Clone and Configure

```bash
git clone <repo-url>
cd devops-project-skeleton
```

### 2. Set Up Terraform Cloud

Update `terraform/environments/<env>/*/remote_state.tf` with your organization:

```hcl
terraform {
    backend "remote" {
        organization = "your-org"
        workspaces {
            name = "your-workspace"
        }
    }
}
```

### 3. Configure SOPS

Import or generate a PGP key and update `.sops.yaml`:

```yaml
creation_rules:
- pgp: YOUR_PGP_KEY_FINGERPRINT
```

### 4. Deploy Your First Environment

```bash
# Initialize and apply global resources (IAM)
cd terraform/environments/env-test1/global
terraform init
terraform plan
terraform apply

# Initialize and apply network resources
cd ../networks
terraform init
terraform plan
terraform apply
```

## Component Reference

### Terraform

**Environments** (`terraform/environments/`)
- Each environment (dev, staging, prod) has its own directory
- `global/` - Account-wide resources: IAM users, groups, policies
- `networks/` - VPCs, subnets, internet gateways, route tables

**Modules** (`terraform/modules/`)
- Reusable modules, primarily sourced from [Terraform AWS Modules](https://registry.terraform.io/namespaces/terraform-aws-modules)

### Ansible

**Configuration** (`ansible/ansible.cfg`)
- 10 parallel forks for faster execution
- Smart fact gathering with JSON file caching
- Python-based dynamic inventory

**Inventories** (`ansible/inventories/`)
- Organized by `<environment>.<region>`
- Group variables for role-specific configuration

### Kubernetes (K3s)

**Clusters** (`kubernetes/clusters/`)
- Manifests organized per cluster
- Uses Traefik as ingress controller
- TLS support for ingress routes

### Secrets Management

**SOPS** (`.sops.yaml`)
- PGP-encrypted secrets
- Decrypted at runtime, never stored in plaintext

## Common Tasks

### Add a New Environment

1. Copy an existing environment:
   ```bash
   cp -r terraform/environments/env-test1 terraform/environments/env-prod
   ```

2. Update `remote_state.tf` with new workspace names

3. Create environment config:
   ```bash
   cp configs/environments/env-name.yaml configs/environments/env-prod.yaml
   ```

### Add IAM Users

Edit `terraform/environments/<env>/global/main.tf` and add users to the appropriate module.

### Manage Secrets

```bash
# Create/edit encrypted secret
sops configs/secrets/my-secret.yaml

# Decrypt to stdout
sops -d configs/secrets/my-secret.yaml
```

### Deploy to K3s

```bash
kubectl apply -f kubernetes/clusters/k3s-local/namespaces/
kubectl apply -f kubernetes/clusters/k3s-local/ingress/
```

## License

This project is provided as a template. Customize as needed for your organization.
