# Kubernetes Cluster Design

## Decisions

| Area | Decision |
|---|---|
| Cloud | Civo |
| Region | LON1 |
| Cluster type | k3s |
| CNI | cilium |
| Environments | separate dev and prod clusters |
| Kubeconfig handling | Civo CLI operator workflow |
| Terraform kubeconfig output | disabled |
| Marketplace apps through Terraform | disabled |

## Cluster Names

| Environment | Cluster |
|---|---|
| dev | terra-dev-k8s |
| prod | terra-prod-k8s |

## Initial Node Pool Design

| Pool | Purpose | Initial Count | Notes |
|---|---|---:|---|
| system | Kubernetes and platform controllers | 1 | cost-conscious training value |
| ingress | Gateway or ingress workloads | 1 | tainted for ingress workloads |
| apps | application workloads | 1 | frontend, backend, admin |

## Future Node Pools

| Pool | Purpose |
|---|---|
| workers | worker services, Jobs, CronJobs |
| observability | monitoring and logging workloads |

## Scheduling Strategy

The platform will use node labels and taints to control placement.

Ingress nodes will be tainted so only ingress workloads with matching tolerations can schedule there.

Application workloads will prefer the apps pool.

Platform controllers will initially run on the system pool where practical.

## Kubeconfig Policy

Terraform must not write kubeconfig into state.

Cluster access will be configured after cluster creation with the Civo CLI.

Example:

```text
civo kubernetes config terra-dev-k8s --save --switch