variable "environment" {
  description = "Environment name for this Terraform root module."
  type        = string

  validation {
    condition     = contains(["prod"], var.environment)
    error_message = "This root module is only for the prod environment."
  }
}

variable "region" {
  description = "Civo region where prod network resources will be created."
  type        = string

  validation {
    condition     = var.region == "LON1"
    error_message = "This course currently expects the prod network root to use Civo region LON1."
  }
}