locals {
  platform    = "terra"
  environment = var.environment

  name_prefix = "${local.platform}-${local.environment}"
}