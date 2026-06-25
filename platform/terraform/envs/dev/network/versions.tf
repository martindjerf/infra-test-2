terraform {
  required_version = ">= 1.6.0, < 2.0.0" # Ensures we use a modern Terraform CLI and avoid accidentally running this with an old version.

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.2.5" # Allows compatible 1.2.x patch releases, but prevents Terraform from jumping to a future 1.3 or 2.x line without review.
    }
  }
}