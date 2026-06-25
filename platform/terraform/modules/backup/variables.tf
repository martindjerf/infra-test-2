variable "name_prefix" {
  description = "Name prefix for environment-scoped resources, such as terra-dev or terra-prod."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be lowercase kebab-case, for example terra-dev."
  }
}

variable "region" {
  description = "Civo region where backup storage will be created."
  type        = string
}

variable "object_store_name" {
  description = "Optional explicit object store name. Defaults to <name_prefix>-velero-backups."
  type        = string
  default     = null
}

variable "max_size_gb" {
  description = "Maximum size of the Civo object store in GB."
  type        = number
  default     = 500

  validation {
    condition     = var.max_size_gb >= 500 && var.max_size_gb % 500 == 0
    error_message = "max_size_gb must be at least 500 and use 500 GB increments."
  }
}