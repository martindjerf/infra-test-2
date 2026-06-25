variable "region" {
  description = "Civo region where the Terraform state object store will be created."
  type        = string

  validation {
    condition     = var.region == "LON1"
    error_message = "This course currently expects the Terraform backend store to be created in Civo region LON1."
  }
}

variable "civo_token" {
  description = "Civo API token used by the Terraform provider."
  type        = string
  sensitive   = true
}