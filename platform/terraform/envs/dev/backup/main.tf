module "backup" {
  source      = "../../../modules/backup"
  name_prefix = local.name_prefix
  region      = var.region
  max_size_gb = var.backup_store_size_gb
}