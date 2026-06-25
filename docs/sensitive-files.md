# Sensitive File Safety

## Never Commit

The following must never be committed:

- Civo API keys
- kubeconfig files
- Terraform state files
- Terraform plan output files
- real `.tfvars` files
- `.env` files
- plain Kubernetes Secret values
- Sealed Secrets private keys
- Velero credential files
- private keys and certificates

## Allowed Examples

Example files may be committed if they contain placeholders only:

- `.env.example`
- `terraform.tfvars.example`
- `dev.tfvars.example`
- `prod.tfvars.example`

## Terraform State Warning

Terraform state may contain sensitive values even when Terraform output marks values as sensitive.

State files must be stored in the configured backend and must not be committed to Git.

## Kubernetes Secret Warning

Kubernetes Secret manifests are not safe to commit just because values are base64 encoded.

Use Sealed Secrets for Git-safe encrypted secret manifests.

## Kubeconfig Warning

A kubeconfig can grant access to a Kubernetes cluster.

Do not commit kubeconfig files. Store them outside the repository or in a secure local location.