# Terraform Backend Bootstrap

## Purpose

This Terraform root module bootstraps the administrative storage used for Terraform remote state.

It is expected to create or manage:

- Terraform state object store
- object store credentials needed for Terraform backend access, if supported by the chosen workflow

## Special Backend Exception

This root module may initially use local Terraform state because its purpose is to create the remote backend used by the rest of the platform.

After bootstrap, normal environment root modules must use remote state.

## Does Not Manage

This root module does not manage:

- dev Kubernetes infrastructure
- prod Kubernetes infrastructure
- application workloads
- Velero backup schedules
- Helm charts
- Argo CD resources

## Planned State Store

Object store name:

```text
terra-tf-state


## Resources

This root creates:

| Resource | Purpose |
|---|---|
| civo_object_store.terraform_state | S3-compatible object store for Terraform remote state |

## Apply Order

This root must be applied before normal environment Terraform roots can use remote state.

## Cost Note

Civo object stores are sized in 500 GB increments. This resource may incur cost after creation.