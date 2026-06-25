# Dev Network Terraform Root

## Purpose

This Terraform root module manages the dev environment network foundation on Civo.

It is expected to manage:

- dev network resources
- dev Kubernetes firewall resources
- firewall rules needed before cluster creation

## Does Not Manage

This root module does not manage:

- Kubernetes clusters
- Kubernetes node pools
- applications
- Helm charts
- Argo CD resources
- in-cluster Kubernetes resources
- backup schedules
- prod resources

## State Boundary

This root module has its own Terraform state.

Expected logical state name:

```text
terra-dev-network

## Remote State Backend

This root stores state in the Terraform administrative object store.

| Setting | Value |
|---|---|
| Backend type | s3 |
| Object store | terra-tf-state |
| State key | terraform/dev/network.tfstate |
| Region | LON1 |

Backend credentials are supplied through environment variables and are not committed to Git.