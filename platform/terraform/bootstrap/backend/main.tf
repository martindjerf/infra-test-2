resource "civo_object_store" "terraform_state" {
  name        = local.state_store_name
  region      = var.region
  max_size_gb = 500
}