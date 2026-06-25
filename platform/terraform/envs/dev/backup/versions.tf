terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.2.5"
    }
  }
}