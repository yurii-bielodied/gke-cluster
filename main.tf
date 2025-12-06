
module "gke_cluster" {
  source           = "./modules/google-gke-cluster"
  GOOGLE_REGION    = var.GOOGLE_REGION
  GOOGLE_PROJECT   = var.GOOGLE_PROJECT
  GKE_NUM_NODES    = var.GKE_NUM_NODES
  GKE_MACHINE_TYPE = var.GKE_MACHINE_TYPE
}

# module "kind_cluster" {
#   source = "./modules/kind-cluster"
# }

module "tls_private_key" {
  source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
  # algorithm   = var.algorithm # (Optional) The algorithm to use for the private key. Default is ECDSA
  # ecdsa_curve = var.ecdsa_curve # (Optional) The curve to use for ECDSA. Default is P256
}

module "github_repository" {
  source                   = "./modules/github-repository"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO                      # (Optional) The name of the repository to create. Default is flux-gitops
  public_key_openssh       = module.tls_private_key.public_key_openssh # The public key to use as a deploy key for the repository
  public_key_openssh_title = "flux"                                    # The title of the public key to use as a deploy key for the repository
  TELE_TOKEN               = var.TELE_TOKEN
}

module "flux_bootstrap" {
  source            = "./modules/fluxcd-flux-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}" # (Required) The name of the Git repository to be created
  private_key       = module.tls_private_key.private_key_pem        # (Optional) The SSH private key to use for Git operations
  github_token      = var.GITHUB_TOKEN
  config_path       = module.gke_cluster.kubeconfig # (Optional) The path to the Kubernetes configuration file. Default value is ~/.kube/config
  # config_path = "${path.root}/kind-cluster-config"
}

provider "kubernetes" {
  config_path = module.gke_cluster.kubeconfig
  # config_path = "${path.root}/kind-cluster-config"
}

resource "kubernetes_secret_v1" "kbot" {
  depends_on = [module.flux_bootstrap]

  metadata {
    name      = "kbot"
    namespace = "kbot"
  }
  data = {
    token = var.TELE_TOKEN
  }
}
