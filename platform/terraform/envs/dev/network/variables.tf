variable "environment" {
  description = "Environment name for this Terraform root module"
  type        = string

  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "This root module is only for the den environment"
  }
}

variable "region" {
  description = "Civo region code where dev network resource will be created"
  type        = string

  validation {
    condition     = var.region == "LON1"
    error_message = "Only region supported is LON1"
  }
}

variable "civo_token" {
  description = "Civo api token used by the terraform prodivder"
  type        = string
  sensitive   = true
}