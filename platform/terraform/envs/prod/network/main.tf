module "network" {
  source = "../../../modules/network"

  name_prefix = local.name_prefix
  region      = var.region
}