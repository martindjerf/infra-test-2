# ADR 0001: Use Civo As The Cloud Platform

## Status

Accepted

## Date

2026-06-23

## Context

The course needs a real cloud provider for managed Kubernetes, infrastructure provisioning, networking, object storage, load balancer integration, and platform operations.

The platform must support hands-on Terraform, Kubernetes, Helm, Argo CD, policy enforcement, backup and restore, and production-style operational workflows.

## Decision

Use Civo as the cloud platform for the course.

The platform will use Civo Kubernetes, Civo networking and firewalls, and Civo object storage where appropriate for backup storage.

## Alternatives Considered

Local-only Kubernetes with kind or k3d was considered. It would reduce cost, but it would not teach real cloud infrastructure ownership, cloud firewalls, managed cluster lifecycle, object storage integration, or external load balancer behavior as effectively.

AWS EKS, Azure AKS, and Google GKE were considered. They are common production choices, but they add more provider-specific identity and networking complexity than needed at this stage of the course.

## Consequences

Civo-specific Terraform resources and operational behavior will be part of the course.

The student must maintain a Civo account, API key, quota, billing, and cloud region selection.

Some design decisions will be tied to Civo capabilities, such as available Kubernetes versions, node sizes, regions, object store support, and load balancer behavior.

The platform will still use portable Kubernetes patterns where possible.