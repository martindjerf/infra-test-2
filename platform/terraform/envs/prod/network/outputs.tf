output "network_id" {
  description = "ID of the prod Civo network."
  value       = module.network.network_id
}

output "network_label" {
  description = "Label of the prod Civo network."
  value       = module.network.network_label
}

output "firewall_id" {
  description = "ID of the prod Civo firewall."
  value       = module.network.firewall_id
}

output "firewall_name" {
  description = "Name of the prod Civo firewall."
  value       = module.network.firewall_name
}