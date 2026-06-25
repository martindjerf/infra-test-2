resource "civo_network" "this" {
  label   = local.network_label
  region  = var.region
  cidr_v4 = var.network_cidr_v4
}

resource "civo_firewall" "k8s" {
  name                 = local.firewall_name
  network_id           = civo_network.this.id
  region               = var.region
  create_default_rules = var.create_default_firewall_rules

  dynamic "ingress_rule" {
    for_each = var.ingress_rules

    content {
      label      = ingress_rule.value.label
      protocol   = ingress_rule.protocol
      port_range = ingress_rule.port_range
      cidr       = ingress_rule.cidr
      action     = ingress_rule.action
    }
  }

  dynamic "egress_rule" {
    for_each = var.egress_rules

    content {
      label      = egress_rule.value.label
      protocol   = egress_rule.value.protocol
      port_range = egress_rule.value.port_range
      cidr       = egress_rule.value.cidr
      action     = egress_rule.value.action
    }
  }

  lifecycle {
    precondition {
      condition     = (var.create_default_firewall_rules && length(var.ingress_rules) == 0 && length(var.egress_rules) == 0) || (!var.create_default_firewall_rules && (length(var.ingress_rules) > 0 || length(var.egress_rules) > 0))
      error_message = "Use either Civo default firewall rules with no custom rules, or disable default rules and provide at least one custom rule"
    }
  }
}