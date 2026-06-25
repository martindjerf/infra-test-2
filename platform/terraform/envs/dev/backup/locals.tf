locals {
  platform     = "terra"
  environement = var.environment

  name_prefix = "${local.platform}-${local.environement}"
}