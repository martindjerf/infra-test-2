variable "cluster_name" {
  description = "Name of the Civo Kubernetes cluster."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.cluster_name))
    error_message = "cluster_name must be lowercase kebab-case, for example terra-dev-k8s."
  }
}

variable "region" {
  description = "Civo region where the Kubernetes cluster will be created."
  type        = string
}

variable "network_id" {
  description = "ID of the Civo network where the cluster will be created."
  type        = string
}

variable "firewall_id" {
  description = "ID of the Civo firewall attached to the cluster."
  type        = string
}

variable "cluster_type" {
  description = "Civo Kubernetes cluster type."
  type        = string
  default     = "k3s"

  validation {
    condition     = contains(["k3s", "talos"], var.cluster_type)
    error_message = "cluster_type must be k3s or talos."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version to install."
  type        = string
}

variable "cni" {
  description = "CNI plugin for the cluster."
  type        = string
  default     = "cilium"

  validation {
    condition     = contains(["cilium", "flannel"], var.cni)
    error_message = "cni must be cilium or flannel."
  }
}

variable "applications" {
  description = "Civo marketplace applications expression. Defaults to removing default Traefik so ingress is managed later by GitOps."
  type        = string
  default     = "-traefik2-nodeport"
}

variable "default_pool" {
  description = "Default node pool created inside the civo_kubernetes_cluster resource."
  type = object({
    label               = string
    size                = string
    node_count          = number
    labels              = optional(map(string), {})
    public_ip_node_pool = optional(bool, false)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  })

  validation {
    condition     = var.default_pool.node_count >= 1
    error_message = "default_pool.node_count must be at least 1."
  }

  validation {
    condition = alltrue([
      for taint in var.default_pool.taints : contains(["NoSchedule", "PreferNoSchedule", "NoExecute"], taint.effect)
    ])
    error_message = "Default pool taint effect must be NoSchedule, PreferNoSchedule, or NoExecute."
  }
}

variable "additional_node_pools" {
  description = "Additional node pools to create after the cluster default pool."
  type = map(object({
    size                = string
    node_count          = number
    labels              = optional(map(string), {})
    public_ip_node_pool = optional(bool, false)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for pool_name, pool in var.additional_node_pools : can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", pool_name))
    ])
    error_message = "Additional node pool names must be lowercase kebab-case."
  }

  validation {
    condition = alltrue([
      for pool_name, pool in var.additional_node_pools : pool.node_count >= 1
    ])
    error_message = "Each additional node pool must have node_count of at least 1."
  }

  validation {
    condition = alltrue(flatten([
      for pool_name, pool in var.additional_node_pools : [
        for taint in pool.taints : contains(["NoSchedule", "PreferNoSchedule", "NoExecute"], taint.effect)
      ]
    ]))
    error_message = "Additional node pool taint effects must be NoSchedule, PreferNoSchedule, or NoExecute."
  }
}