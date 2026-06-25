locals {
  platform     = "terra"
  environement = var.environment

  name_prefix  = "${local.platform}-${local.environement}"
  cluster_name = "${local.name_prefix}-k8s"
}