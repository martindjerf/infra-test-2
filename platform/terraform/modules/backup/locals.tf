locals {
  object_store_name = coalesce(var.object_store_name, "${var.name_prefix}-velero-backups")
}