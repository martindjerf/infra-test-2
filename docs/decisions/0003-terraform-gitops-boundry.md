# ADR 0003: Separate Terraform Infrastructure Ownership From GitOps Workload Ownership

## Status

Accepted

## Date

2026-06-23

## Context

The platform needs both infrastructure provisioning and continuous Kubernetes workload reconciliation.

Terraform can manage cloud infrastructure well, while Argo CD can continuously reconcile Kubernetes resources from Git.

Using both tools without a clear boundary can cause ownership conflicts, drift, duplicated deployment paths, and confusing incident response.

## Decision

Terraform will manage Civo infrastructure and foundational cloud resources.

Argo CD will manage in-cluster Kubernetes desired state, including applications, Helm releases, namespaces, policies, SealedSecret resources, NetworkPolicies, Gateway or Ingress routing, and platform services after bootstrap.

Terraform may expose cluster connection outputs, but it should not become the long-term owner of application workloads.

## Alternatives Considered

Managing most Kubernetes resources with Terraform was considered. This can work for limited cases, but it makes continuous application delivery and drift correction less natural.

Managing cloud infrastructure through Kubernetes controllers was considered. This would require additional control-plane components and increase scope before the core Terraform workflow is learned.

Manual `kubectl apply` deployment was considered for early lessons only. It is useful for learning Kubernetes objects, but it is not an acceptable long-term production delivery model.

## Consequences

The platform has clear ownership boundaries.

Terraform plans remain focused on infrastructure.

Argo CD becomes the source of truth for in-cluster desired state.

Bootstrap must be handled carefully because Argo CD must exist before it can manage the rest of the cluster.