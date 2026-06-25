output "object_store_id" {
  description = "ID of the Civo object store used for Velero backups."
  value       = civo_object_store.velero_backups.id
}

output "object_store_name" {
  description = "Name of the Civo object store used for Velero backups."
  value       = civo_object_store.velero_backups.name
}

output "bucket_url" {
  description = "S3-compatible endpoint URL for the backup object store."
  value       = civo_object_store.velero_backups.bucket_url
}

output "access_key_id" {
  description = "Access key ID associated with the backup object store."
  value       = civo_object_store.velero_backups.access_key_id
  sensitive   = true
}