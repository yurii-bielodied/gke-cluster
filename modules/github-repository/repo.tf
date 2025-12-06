provider "github" {
  owner = var.github_owner
  token = var.github_token
}

resource "github_repository" "repo" {
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true
}

resource "github_repository_deploy_key" "repo" {
  title      = var.public_key_openssh_title
  repository = github_repository.repo.name
  key        = var.public_key_openssh
  read_only  = false
}

resource "github_repository_file" "cicd_workflow" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = ".github/workflows/cicd.yaml"
  content             = file("${path.module}/templates/cicd.yaml")
  commit_message      = "Add CI/CD workflow"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "kbot-git" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = "clusters/kbot/kbot-git.yaml"
  content             = file("${path.module}/templates/kbot-git.yaml")
  commit_message      = "Add kbot-git file"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "kbot-helm" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = "clusters/kbot/kbot-helm.yaml"
  content             = file("${path.module}/templates/kbot-helm.yaml")
  commit_message      = "Add kbot-helm file"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "ns" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = "clusters/kbot/ns.yaml"
  content             = file("${path.module}/templates/ns.yaml")
  commit_message      = "Add ns file"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "secret" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = "clusters/kbot/secret.yaml"
  content             = file("${path.module}/templates/secret.yaml")
  commit_message      = "Add secret file"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# resource "github_codespaces_secret" "kbot" {
#   repository      = github_repository.repo.name
#   secret_name     = "token"
#   plaintext_value = var.TELE_TOKEN
# }
