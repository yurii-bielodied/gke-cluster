terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
  }
}

provider "flux" {
  kubernetes = {
    config_path = var.config_path
  }
  git = {
    url = "https://github.com/${var.github_repository}.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}

resource "flux_bootstrap_git" "flux" {
  namespace = "flux"
  path      = var.target_path
}
