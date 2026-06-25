resource "civo_object_store" "velero_backups" {
  name        = local.object_store_name
  region      = var.region
  max_size_gb = var.max_size_gb
}