output "cluster_id" {
  description = "ID of the Civo Kubernetes cluster."
  value       = civo_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the Civo Kubernetes cluster."
  value       = civo_kubernetes_cluster.this.name
}

output "api_endpoint" {
  description = "Kubernetes API endpoint for the cluster."
  value       = civo_kubernetes_cluster.this.api_endpoint
}

output "dns_entry" {
  description = "DNS entry for the cluster."
  value       = civo_kubernetes_cluster.this.dns_entry
}

output "master_ip" {
  description = "Master node IP address."
  value       = civo_kubernetes_cluster.this.master_ip
}

output "status" {
  description = "Cluster status."
  value       = civo_kubernetes_cluster.this.status
}

output "ready" {
  description = "Whether the cluster is ready."
  value       = civo_kubernetes_cluster.this.ready
}

output "default_pool_label" {
  description = "Label of the default cluster node pool."
  value       = var.default_pool.label
}

output "default_pool_instance_names" {
  description = "Instance names in the default node pool."
  value       = civo_kubernetes_cluster.this.pools[0].instance_names
}

output "additional_node_pool_ids" {
  description = "IDs of additional node pools."
  value = {
    for pool_name, pool in civo_kubernetes_node_pool.additional : pool_name => pool.id
  }
}

output "additional_node_pool_instance_names" {
  description = "Instance names in additional node pools."
  value = {
    for pool_name, pool in civo_kubernetes_node_pool.additional : pool_name => pool.instance_names
  }
}