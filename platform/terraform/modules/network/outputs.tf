output "network_id" {
  description = "ID of the civo network"
  value       = civo_network.this.id
}

output "network_label" {
  description = "Label of the Civo network"
  value       = civo_network.this.label
}

output "network_name" {
  description = "Name of the Civo network"
  value       = civo_network.this.name
}

output "firewall_id" {
  description = "ID of the Civo firewall for Kubernetes resources."
  value       = civo_firewall.k8s.id
}

output "firewall_name" {
  description = "Name of the Civo firewall for Kubernetes resources."
  value       = civo_firewall.k8s.name
}