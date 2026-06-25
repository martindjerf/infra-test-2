locals {
  network_label = coalesce(var.network_label, "${var.name_prefix}-network")
  firewall_name = coalesce(var.firewall_name, "${var.name_prefix}-firewall-k8s")
}