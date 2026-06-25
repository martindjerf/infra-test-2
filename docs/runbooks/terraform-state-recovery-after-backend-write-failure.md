# Terraform State Recovery After Backend Write Failure

## Purpose

Use this runbook when Terraform successfully creates or changes real infrastructure, but then fails to write the updated state to the configured backend.

This can happen with an error similar to:

```text
Error: Failed to save state
Error saving state: failed to upload state
Failed to persist state to backend
The state has been written to the file "errored.tfstate"
```

In this situation, the infrastructure may already exist, but the remote Terraform state may not know about it yet.

## Critical Rule

Do not run `terraform apply` again.

Running apply again before recovering state can create duplicate resources, fork state, or make recovery harder.

## Expected Recovery File

Terraform should create:

```text
errored.tfstate
```

Treat this file as the temporary source of truth until the backend state is recovered.

Do not commit this file.

## Recovery Steps

### 1. Stay In The Failed Root Module

Run recovery from the same Terraform root where the failure happened.

Example:

```powershell
cd platform\terraform\envs\dev\network
```

### 2. Create A Local Backup Of The Recovery State

```powershell
Copy-Item -LiteralPath .\errored.tfstate -Destination .\errored.recovery.tfstate
```

For an environment-specific recovery, use a clearer name:

```powershell
Copy-Item -LiteralPath .\errored.tfstate -Destination .\errored.dev-network.recovery.tfstate
```

### 3. Inspect The Recovery State

First confirm the recovery files exist in the current root module:

```powershell
Get-ChildItem -Force .\errored*.tfstate
```

Inspect the recovery state directly:

```powershell
terraform show .\errored.tfstate
```

Confirm the state contains only resources expected for that root module.

For `dev/network`, the expected resources are:

```text
module.network.civo_firewall.k8s
module.network.civo_network.this
```

For `dev/backup`, the expected resource is:

```text
module.backup.civo_object_store.velero_backups
```

If useful, also try listing state addresses explicitly:

```powershell
terraform state list -state=.\errored.tfstate
```

If `terraform state list` cannot read the local recovery file but `terraform show .\errored.tfstate` displays the expected resources, continue with the recovery.

Stop if the recovery state contains unexpected environments, unrelated resources, or destroy-related changes.

### 4. Check Backend Configuration

Open the root module backend file.

Example:

```text
platform/terraform/envs/dev/network/backend.tf
```

For the Civo S3-compatible backend, confirm:

```hcl
bucket = "terra-tf-state"
key    = "terraform/dev/network.tfstate"
region = "LON1"

endpoints = {
  s3 = "https://objectstore.lon1.civo.com"
}

use_path_style = true

skip_credentials_validation = true
skip_region_validation      = true
skip_requesting_account_id  = true
skip_metadata_api_check     = true
skip_s3_checksum            = true
```

The endpoint should be the base S3 endpoint, not a URL that includes the bucket name.

Do not use this setting with the current Civo object store backend:

```hcl
use_lockfile = true
```

The backend rejected `.tflock` writes during testing.

### 5. Reset AWS Credential Discovery Noise

Terraform's S3 backend uses AWS-compatible credential environment variables. If AWS profile or SSO variables are set, Terraform may try the wrong credential source.

Remove profile/session variables:

```powershell
Remove-Item Env:AWS_PROFILE -ErrorAction SilentlyContinue
Remove-Item Env:AWS_DEFAULT_PROFILE -ErrorAction SilentlyContinue
Remove-Item Env:AWS_SESSION_TOKEN -ErrorAction SilentlyContinue
Remove-Item Env:AWS_WEB_IDENTITY_TOKEN_FILE -ErrorAction SilentlyContinue
Remove-Item Env:AWS_ROLE_ARN -ErrorAction SilentlyContinue
Remove-Item Env:AWS_SDK_LOAD_CONFIG -ErrorAction SilentlyContinue
```

Set compatibility flags:

```powershell
$env:AWS_EC2_METADATA_DISABLED = "true"
$env:AWS_REQUEST_CHECKSUM_CALCULATION = "when_required"
$env:AWS_RESPONSE_CHECKSUM_VALIDATION = "when_required"
```

Set the Civo object store backend credentials:

```powershell
$env:AWS_ACCESS_KEY_ID = "<CIVO_OBJECT_STORE_ACCESS_KEY_ID>"
$env:AWS_SECRET_ACCESS_KEY = "<CIVO_OBJECT_STORE_SECRET_KEY>"
```

Set the Civo API token for the provider:

```powershell
$env:CIVO_TOKEN = "<CIVO_API_TOKEN>"
```

Do not write these values to Terraform files, Markdown, `.tfvars`, or Git.

In PowerShell, verify `CIVO_TOKEN` with `$env:CIVO_TOKEN` or `Get-ChildItem Env:CIVO_TOKEN`. Do not rely on CMD-style `%CIVO_TOKEN%` syntax.

### 6. Confirm Required Variables Are Present

Check that required variables exist without printing secret values:

```powershell
$names = "AWS_ACCESS_KEY_ID","AWS_SECRET_ACCESS_KEY","CIVO_TOKEN","AWS_PROFILE","AWS_DEFAULT_PROFILE","AWS_SESSION_TOKEN"
foreach ($name in $names) {
  if (Test-Path "Env:\$name") { "$name is set" } else { "$name is missing" }
}
```

Expected:

```text
AWS_ACCESS_KEY_ID is set
AWS_SECRET_ACCESS_KEY is set
CIVO_TOKEN is set
AWS_PROFILE is missing
AWS_DEFAULT_PROFILE is missing
AWS_SESSION_TOKEN is missing
```

### 7. Reinitialize The Backend

```powershell
terraform init -reconfigure
```

Expected:

```text
Terraform has been successfully initialized!
```

### 8. Push The Recovery State

```powershell
terraform state push errored.tfstate
```

This writes the recovered local state to the configured backend.

Stop if this fails. Do not run `terraform apply`.

### 9. Verify Terraform And Real Infrastructure Agree

Run:

```powershell
terraform plan
```

Expected:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms the backend state, Terraform configuration, and real infrastructure are aligned.

### 10. Clean Local Recovery Files

Only after a clean `terraform plan`, remove local recovery and plan files:

```powershell
Remove-Item -LiteralPath .\errored.tfstate -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\errored.recovery.tfstate -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\errored.dev-network.recovery.tfstate -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\errored.dev-backup.recovery.tfstate -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\dev-network.tfplan -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\dev-backup.tfplan -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\prod-network.tfplan -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\prod-backup.tfplan -ErrorAction SilentlyContinue
```

Adjust filenames for the root module being recovered.

### 11. Check Git Safety

```powershell
git status --short
```

These files must not appear:

```text
errored.tfstate
*.recovery.tfstate
*.tfplan
terraform.tfstate
terraform.tfstate.backup
.terraform/
terraform.tfvars
```

If they appear, fix `.gitignore` before committing anything.

## Follow-Up Documentation

After recovery, record:

- which root module failed
- which real resources were already created
- why backend write failed, if known
- the command used to push recovery state
- the final `terraform plan` result

Example:

```text
The dev network apply created terra-dev-network and terra-dev-firewall-k8s, then failed to persist state to the Civo S3-compatible backend.
Terraform wrote errored.tfstate.
The recovery state was pushed with terraform state push errored.tfstate.
A follow-up terraform plan returned no changes.
```

## When To Escalate

Escalate or stop for deeper review if:

- `errored.tfstate` is missing
- `terraform state push errored.tfstate` fails
- the recovery state contains unexpected resources
- `terraform plan` wants to recreate resources that already exist
- `terraform plan` shows destroy actions
- the backend continues to fail with checksum or credential errors

Do not continue with normal Terraform operations until state is consistent.
