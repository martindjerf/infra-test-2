output "backup_object_store_id" {
  description = "ID of the dev Velero backup object store."
  value       = module.backup.object_store_id
}

output "backup_object_store_name" {
  description = "Name of the dev Velero backup object store."
  value       = module.backup.object_store_name
}

output "backup_bucket_url" {
  description = "S3-compatible endpoint URL for the dev Velero backup object store."
  value       = module.backup.bucket_url
}

output "backup_access_key_id" {
  description = "Access key ID associated with the dev Velero backup object store."
  value       = module.backup.access_key_id
  sensitive   = true
}