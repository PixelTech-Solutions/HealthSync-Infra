# HealthSync Infrastructure — Terraform

> Infrastructure as Code for the HealthSync healthcare platform on Azure.  
> All 21 Azure resources managed via reusable Terraform modules.

## Architecture
```
infra/
  modules/                          # Reusable Terraform modules
    resource-group/                 # Azure Resource Group
    managed-identity/               # User-Assigned Managed Identity
    key-vault/                      # Azure Key Vault (RBAC mode)
    cosmos-db/                      # Cosmos DB (MongoDB API, Serverless)
    postgresql/                     # PostgreSQL Flexible Server
    redis/                          # Azure Cache for Redis
    service-bus/                    # Service Bus Namespace + Queues
    communication-services/         # ACS + Email Service + Domain
    acr/                            # Azure Container Registry
    container-apps-environment/     # CAE + Log Analytics Workspace
    container-app/                  # Reusable Container App
    storage-account/                # Storage Account + Static Website
    front-door/                     # Azure Front Door CDN
  healthsync/                       # Service composition
    provider.tf                     # azurerm ~4.0 + backend
    data.tf                         # Data sources
    locals.tf                       # Naming conventions + computed values
    variables.tf                    # Input variables
    main.tf                         # Foundation (RG, Identity, ACR, Roles)
    databases.tf                    # Cosmos DB, PostgreSQL, Redis
    security.tf                     # Key Vault + 16 secrets
    compute.tf                      # CAE + Service Bus + 7 Container Apps
    networking.tf                   # Storage Account + Front Door
    communication.tf                # ACS Email
    outputs.tf                      # URLs, FQDNs, IDs
    environments/
      dev.tfvars                    # Dev environment values
      prod.tfvars                   # Prod environment (placeholder)
.github/workflows/
  infra-dev.yml                     # Dev environment — calls org template
```

## Azure Resources Created (21)
| # | Resource | Module | Naming |
|---|----------|--------|--------|
| 1 | Resource Group | `resource-group` | `rg-healthsync-{env}` |
| 2 | User-Assigned Managed Identity | `managed-identity` | `id-healthsync-{env}` |
| 3 | Key Vault (16 secrets, RBAC) | `key-vault` | `kv-healthsync-{env}` |
| 4 | Cosmos DB (MongoDB, Serverless, 4 DBs) | `cosmos-db` | `cosmos-healthsync-{env}` |
| 5 | PostgreSQL Flexible Server (3 DBs) | `postgresql` | `psql-healthsync-{env}` |
| 6 | Azure Cache for Redis (Basic C0) | `redis` | `redis-healthsync-{env}` |
| 7 | Service Bus (Basic, 3 queues) | `service-bus` | `sb-healthsync-{env}` |
| 8 | Communication Services | `communication-services` | `acs-healthsync-{env}` |
| 9 | Email Communication Services | `communication-services` | `ecs-healthsync-{env}` |
| 10 | Container Registry (Basic) | `acr` | `crhealthsync` |
| 11 | Log Analytics Workspace | `container-apps-environment` | `law-healthsync-{env}` |
| 12 | Container Apps Environment | `container-apps-environment` | `cae-healthsync-{env}` |
| 13 | ca-api-gateway (external) | `container-app` | — |
| 14 | ca-doctor-service (internal) | `container-app` | — |
| 15 | ca-appointment-service (internal) | `container-app` | — |
| 16 | ca-patient-service (internal) | `container-app` | — |
| 17 | ca-prescription-service (internal) | `container-app` | — |
| 18 | ca-payment-service (internal) | `container-app` | — |
| 19 | ca-notification-service (internal, min=1) | `container-app` | — |
| 20 | Storage Account (static website + avatars) | `storage-account` | `sthealthsyncweb` |
| 21 | Azure Front Door (Standard CDN) | `front-door` | `fd-healthsync` |

## Prerequisites

1. **GitHub Secrets** configured (for CI/CD):

| Secret | Purpose |
|--------|---------|
| `ARM_CLIENT_ID` | Service Principal client ID |
| `ARM_CLIENT_SECRET` | Service Principal secret |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure AD tenant ID |

> State backend (`rg-terraform-state` / `stpixeltechstate` / `tfstate`) is managed by the [PixelTech-Solutions/Terraform](https://github.com/PixelTech-Solutions/Terraform) reusable workflow — no extra setup needed.

2. **GitHub Environments** created in repo Settings → Environments:
   - `dev` — add required reviewers (gates Apply)
   - `dev-destroy` — add required reviewers (gates Destroy)

3. **Sensitive Terraform variables** set via `TF_VAR_*` environment variables or GitHub Actions secrets:

| Variable | Purpose |
|----------|---------|
| `TF_VAR_postgresql_admin_password` | PostgreSQL admin password |
| `TF_VAR_jwt_secret` | JWT access token signing secret |
| `TF_VAR_jwt_refresh_secret` | JWT refresh token signing secret |
| `TF_VAR_stripe_secret_key` | Stripe API secret key |
| `TF_VAR_stripe_publishable_key` | Stripe publishable key |

## Quick Start (Local)

```bash
cd infra/healthsync

# Set sensitive variables
export TF_VAR_postgresql_admin_password="<password>"
export TF_VAR_jwt_secret="<secret>"
export TF_VAR_jwt_refresh_secret="<secret>"
export TF_VAR_stripe_secret_key="<stripe-sk>"
export TF_VAR_stripe_publishable_key="<stripe-pk>"

# Init with org state backend
terraform init \
  -backend-config="resource_group_name=rg-terraform-state" \
  -backend-config="storage_account_name=stpixeltechstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=healthsync/healthsync-infra/dev/terraform.tfstate"

# Plan
terraform plan -var-file=environments/dev.tfvars

# Apply
terraform apply -var-file=environments/dev.tfvars
```

## CI/CD

Push to `main` (paths: `infra/**`) or trigger `workflow_dispatch` → calls the [PixelTech-Solutions/Terraform](https://github.com/PixelTech-Solutions/Terraform) reusable workflow:

1. **Format Check** → **Validate** → **Plan** (automatic)
2. **Apply** — pauses with "Review deployments" button (requires `dev` environment reviewers)
3. **Destroy** — pauses with "Review deployments" button (requires `dev-destroy` environment reviewers)

```yaml
# .github/workflows/infra-dev.yml
jobs:
  dev:
    uses: PixelTech-Solutions/Terraform/.github/workflows/terraform.yml@main
    with:
      working_directory: ./infra/healthsync
      environment: dev
      project_name: healthsync
      service_name: healthsync-infra
    secrets: inherit
```

## State Key Convention

```
{project_name}/{service_name}/{environment}/terraform.tfstate
→ healthsync/healthsync-infra/dev/terraform.tfstate
```
