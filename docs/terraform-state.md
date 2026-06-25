# Terraform State Strategy

## Principle

Terraform state is a blast-radius boundary.

Each environment layer uses a separate Terraform root module and a separate state object.

## Backend

The course uses a Civo Object Store as the target remote backend for normal Terraform root modules.

The backend bootstrap root may initially use local state only to create the administrative backend storage.

## Administrative State Store

Planned object store:

```text
terra-tf-state
```

## Backend Bootstrap Result

Terraform state object store:

```text
terra-tf-state
```

Region:

```text
LON1
```

Bucket endpoint:

```text
objectstore.lon1.civo.com
```

The access key and secret key are not documented in Git.

## State Keys

| Root Module | State Key |
|---|---|
| platform/terraform/envs/dev/network | terraform/dev/network.tfstate |
| platform/terraform/envs/dev/cluster | terraform/dev/cluster.tfstate |
| platform/terraform/envs/dev/backup | terraform/dev/backup.tfstate |
| platform/terraform/envs/prod/network | terraform/prod/network.tfstate |
| platform/terraform/envs/prod/cluster | terraform/prod/cluster.tfstate |
| platform/terraform/envs/prod/backup | terraform/prod/backup.tfstate |

## State Locking Note

Terraform S3 lockfile support was tested against the Civo object store backend.

The backend initialized successfully, but Terraform failed to create the `.tflock` object with an `XAmzContentSHA256Mismatch` error.

For now, `use_lockfile` is disabled for Civo-backed Terraform state.

Because this is a single-operator training platform, the operational rule is that only one Terraform operation may run against a given state at a time.

This should be revisited before team use or production use.

## State Recovery Runbook

If Terraform creates real infrastructure but fails to persist state to the backend, do not run `terraform apply` again.

Follow the recovery runbook:

```text
docs/runbooks/terraform-state-recovery-after-backend-write-failure.md
```

## Dev Backup State Recovery

During the first dev backup apply, Civo created `terra-dev-velero-backups`, but Terraform failed to persist state to the Civo S3-compatible backend with an `XAmzContentSHA256Mismatch` error.

Terraform wrote recovery state to `errored.tfstate`.

The recovery state was pushed with:

```text
terraform state push errored.tfstate
```

A follow-up `terraform plan` returned no changes.
