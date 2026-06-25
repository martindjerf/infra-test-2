output "cluster_id" {
  description = "ID of the dev Kubernetes cluster"
  value       = module.cluster.cluster_id
}

output "cluster_name" {
  description = "Name of the dev Kubernetes cluster"
  value       = module.cluster.cluster_name
}

output "api_endpoint" {
  description = "Kubernetes API endpoint for the dev cluster"
  value       = module.cluster.api_endpoint
}

output "dns_entry" {
  description = "DNS entry for the dev cluster"
  value       = module.cluster.dns_entry
}

output "master_ip" {
  description = "MasterIP for the dev cluster"
  value       = module.cluster.master_ip
}

output "status" {
  description = "Status of the dev cluster"
  value       = module.cluster.status
}

output "ready" {
  description = "Whether the dev cluster is ready."
  value       = module.cluster.ready
}

output "network_id" {
  description = "Network ID used by the dev cluster."
  value       = data.terraform_remote_state.network.outputs.network_id
}

output "firewall_id" {
  description = "Firewall ID used by the dev cluster."
  value       = data.terraform_remote_state.network.outputs.firewall_id
}