# CLAUDE.md

This file provides context for AI assistants working with this codebase.

## Project Overview

DevOps Infrastructure-as-Code (IaC) skeleton/boilerplate for bootstrapping new AWS accounts and projects. Provides a standardized structure for managing cloud infrastructure, configuration, and container orchestration.

## Tech Stack

- **Terraform** - AWS infrastructure provisioning (uses Terraform Cloud for remote state)
- **Ansible** - Configuration management with Python-based dynamic inventory
- **Kubernetes (K3s)** - Lightweight container orchestration
- **SOPS** - Secrets encryption with PGP keys
- **Traefik** - Ingress controller for K3s

## Directory Structure

```
terraform/
  environments/<env-name>/   # Per-environment infrastructure
    global/                  # IAM, users, account-wide resources
    networks/                # VPCs, subnets, networking
  modules/                   # Reusable Terraform modules

ansible/
  inventories/               # Dynamic inventory (Python-based)
  ansible.cfg                # Ansible configuration

kubernetes/
  clusters/<cluster-name>/   # K8s manifests per cluster
    ingress/                 # Ingress rules
    namespaces/              # Namespace definitions

configs/
  environments/              # Environment config templates (YAML)
  secrets/                   # SOPS-encrypted secrets
  users/                     # SSH public keys
```

## Key Conventions

### Terraform
- Environments live in `terraform/environments/<env-name>/`
- Each environment has `global/` (IAM) and `networks/` (VPC) subdirectories
- Uses Terraform Cloud backend with organization "fakoli"
- Modules sourced from Terraform Registry (`terraform-aws-modules`)
- Workspace naming: `<env-name>-<component>` (e.g., `env-test1-global`)

### Ansible
- Inventory driven by `inventories/inventory.py` (Python script)
- Group variables in `inventories/<env>.<region>/group_vars/`
- 10 parallel forks, smart fact gathering with JSON caching

### Secrets
- SOPS config in `.sops.yaml` at repo root
- PGP key fingerprint required for encryption/decryption
- Encrypted files stored in `configs/secrets/`

### Kubernetes
- K3s cluster manifests in `kubernetes/clusters/k3s-local/`
- Uses Traefik ingress class
- nip.io domains for local development (e.g., `*.172.16.2.10.nip.io`)

## Common Commands

```bash
# Terraform
cd terraform/environments/env-test1/global
terraform init
terraform plan
terraform apply

# Ansible
cd ansible
ansible-playbook -i inventories/inventory.py playbook.yml

# SOPS
sops configs/secrets/example.yaml        # Edit encrypted file
sops -d configs/secrets/example.yaml     # Decrypt to stdout
```

## Adding New Environments

1. Copy `terraform/environments/env-test1/` to new env name
2. Update `remote_state.tf` with new workspace names
3. Create corresponding `configs/environments/<env>.yaml`
4. Add inventory in `ansible/inventories/<env>.<region>/`
