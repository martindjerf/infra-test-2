# ADR 0002: Use Separate Kubernetes Clusters For Dev And Prod

## Status

Accepted

## Date

2026-06-23

## Context

The course platform needs at least two environments. These environments must support realistic promotion, testing, operational isolation, policy testing, and disaster recovery practice.

The main options are separate namespaces in one cluster or separate Kubernetes clusters.

## Decision

Use separate Civo Kubernetes clusters for dev and prod.

Each environment will have its own cluster, Terraform state boundaries, Kubernetes API endpoint, Argo CD installation, policy enforcement, Sealed Secrets controller, Velero configuration, and application workloads.

## Alternatives Considered

A single shared cluster with separate namespaces was considered. This would reduce cost and simplify provisioning, but it would weaken isolation and make some production-style operational lessons less realistic.

A multi-region cluster strategy was considered. This would improve disaster recovery realism, but it adds complexity that should be deferred until the core platform is working.

## Consequences

The platform has stronger isolation between dev and prod.

The course can safely practice destructive testing, broken policies, failed rollouts, and restores in dev before applying lessons to prod.

Cloud cost and operational overhead are higher than a single-cluster setup.

Configuration duplication must be controlled through reusable Terraform modules, Helm charts, and GitOps environment composition.