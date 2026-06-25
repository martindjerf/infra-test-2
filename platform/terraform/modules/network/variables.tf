variable "name_prefix" {
  description = "Name prefix for environement-scoped resources, such as terra-dev or terra-prod"
  type = string

  validation {
    condition = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be lowercase kebab-case"
  }
}

variable "region" {
  description = "Civo region where network resources will be created."
  type        = string
}

variable "network_label" {
  description = "Optional explicit Civo network label. Defaults to <name_prefix>-network."
  type        = string
  default     = null
}

variable "network_cidr_v4" {
  description = "Optional IPv4 CIDR block for the Civo network."
  type        = string
  default     = null
}

variable "firewall_name" {
  description = "Optional explicit Civo firewall name. Defaults to <name_prefix>-firewall-k8s."
  type        = string
  default     = null
}

variable "create_default_firewall_rules" {
  description = "Whether Civo should create its default firewall rules. Must be false when custom rules are supplied."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Custom ingress firewall rules. Only used when create_default_firewall_rules is false."
  type = list(object({
    label      = optional(string)
    protocol   = optional(string, "tcp")
    port_range = optional(string)
    cidr       = set(string)
    action     = optional(string, "allow")
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : contains(["tcp", "udp", "icmp"], rule.protocol)
    ])
    error_message = "Ingress rule protocol must be tcp, udp, or icmp."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : contains(["allow", "deny"], rule.action)
    ])
    error_message = "Ingress rule action must be allow or deny."
  }
}

variable "egress_rules" {
  description = "Custom egress firewall rules. Only used when create_default_firewall_rules is false."
  type = list(object({
    label      = optional(string)
    protocol   = optional(string, "tcp")
    port_range = optional(string)
    cidr       = set(string)
    action     = optional(string, "allow")
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["tcp", "udp", "icmp"], rule.protocol)
    ])
    error_message = "Egress rule protocol must be tcp, udp, or icmp."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["allow", "deny"], rule.action)
    ])
    error_message = "Egress rule action must be allow or deny."
  }
}