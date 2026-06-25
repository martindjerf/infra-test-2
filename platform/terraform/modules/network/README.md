# Civo Network Module

## Purpose

This module creates the Civo network foundation for one environment.

It manages:

- one Civo network
- one Civo firewall intended for Kubernetes cluster use

## Does Not Manage

This module does not manage:

- Kubernetes clusters
- node pools
- object stores
- applications
- Kubernetes manifests
- Argo CD resources

## Naming

Default resource names are derived from `name_prefix`.

Examples:

- `terra-dev-network`
- `terra-dev-firewall-k8s`
- `terra-prod-network`
- `terra-prod-firewall-k8s`

## Firewall Rules

By default, the module allows Civo to create default firewall rules.

Custom firewall rules can be supplied by setting:

```hcl
create_default_firewall_rules = false