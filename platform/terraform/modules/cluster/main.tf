resource "civo_kubernetes_cluster" "this" {
  name               = var.cluster_name
  region             = var.region
  network_id         = var.network_id
  firewall_id        = var.firewall_id
  cluster_type       = var.cluster_type
  kubernetes_version = var.kubernetes_version
  cni                = var.cni
  applications       = var.applications
  write_kubeconfig   = false
  tags               = local.common_tags

  pools {
    label               = var.default_pool.label
    size                = var.default_pool.size
    node_count          = var.default_pool.node_count
    labels              = var.default_pool.labels
    public_ip_node_pool = var.default_pool.public_ip_node_pool

    dynamic "taint" {
      for_each = var.default_pool.taints

      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  lifecycle {
    ignore_changes = [ 
        tags,
        pools[0].labels
     ]
  }
}

resource "civo_kubernetes_node_pool" "additional" {
  for_each = var.additional_node_pools

  cluster_id          = civo_kubernetes_cluster.this.id
  label               = each.key
  size                = each.value.size
  node_count          = each.value.node_count
  labels              = each.value.labels
  public_ip_node_pool = each.value.public_ip_node_pool

  dynamic "taint" {
    for_each = each.value.taints

    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}