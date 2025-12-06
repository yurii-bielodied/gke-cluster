
terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.7.6"
    }
    github = {
      source  = "integrations/github"
      version = "6.8.3"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.12.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "0.10"
    }
  }
  backend "gcs" {
    bucket = "gke-cluster-tf-state"
    prefix = "terraform/state"
  }
}
