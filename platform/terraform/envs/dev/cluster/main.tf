module "cluster" {
  source = "../../../modules/cluster"

  cluster_name = local.cluster_name
  region       = var.region
  network_id   = data.terraform_remote_state.network.outputs.network_id
  firewall_id  = data.terraform_remote_state.network.outputs.firewall_id

  cluster_type       = "k3s"
  kubernetes_version = var.kubernetes_version
  cni                = "cilium"

  default_pool = {
    label      = "system"
    size       = var.node_size
    node_count = 1

    labels = {
      nodepool = "system"
      workload = "platform"
    }
  }

  additional_node_pools = {
    ingress = {
      size       = var.node_size
      node_count = 1

      labels = {
        nodepool = "ingress"
        workload = "ingress"
      }

      taints = [
        {
          key    = "dedicated"
          value  = "ingress"
          effect = "NoSchedule"
        }
      ]
    }

    apps = {
      size       = var.node_size
      node_count = 1

      labels = {
        nodepool = "apps"
        workload = "apps"
      }
    }
  }

}