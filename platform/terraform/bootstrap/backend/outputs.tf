output "state_store_name" {
  description = "Name of the Civo object store used for Terraform remote state."
  value       = civo_object_store.terraform_state.name
}

output "state_store_bucket_url" {
  description = "S3-compatible endpoint URL for the Terraform state object store."
  value       = civo_object_store.terraform_state.bucket_url
}

output "state_store_access_key_id" {
  description = "Access key ID associated with the Terraform state object store."
  value       = civo_object_store.terraform_state.access_key_id
  sensitive   = true
}