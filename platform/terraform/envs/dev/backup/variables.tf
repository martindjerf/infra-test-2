variable "environment" {
  description = "Environment name for this Terraform root module."
  type        = string

  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "This root module is only for the dev environment."
  }
}

variable "region" {
  description = "Civo region where dev backup storage will be created."
  type        = string

  validation {
    condition     = var.region == "LON1"
    error_message = "This course currently expects the dev backup root to use Civo region LON1."
  }
}

variable "backup_store_size_gb" {
  description = "Size of the dev Velero backup object store in GB."
  type        = number
  default     = 500

  validation {
    condition     = var.backup_store_size_gb >= 500 && var.backup_store_size_gb % 500 == 0
    error_message = "backup_store_size_gb must be at least 500 and use 500 GB increments."
  }
}