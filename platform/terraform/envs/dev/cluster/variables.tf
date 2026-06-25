variable "environment" {
  description = "Environment name for this Terraform root module."
  type        = string

  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "This root module is only for the dev environment."
  }
}

variable "region" {
  description = "Civo region where the dev Kubernetes cluster will be created."
  type        = string

  validation {
    condition     = var.region == "LON1"
    error_message = "This course currently expects the dev cluster root to use Civo region LON1."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version for the dev cluster."
  type        = string
  default     = "1.35.0-k3s1"

  validation {
    condition     = var.kubernetes_version == "1.35.0-k3s1"
    error_message = "This course currently expects Kubernetes version 1.35.0-k3s1."
  }
}

variable "node_size" {
  description = "Civo Kubernetes node size for initial dev node pools."
  type        = string
  default     = "g4s.kube.small"

  validation {
    condition     = var.node_size == "g4s.kube.small"
    error_message = "This course currently expects g4s.kube.small for initial node pools."
  }
}