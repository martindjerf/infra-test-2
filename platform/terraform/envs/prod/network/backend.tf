terraform {
  backend "s3" {
    bucket = "terra-tf-state"
    key    = "terraform/prod/network.tfstate"
    region = "LON1"

    endpoints = {
      s3 = "https://objectstore.lon1.civo.com"
    }

    use_path_style = true

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}