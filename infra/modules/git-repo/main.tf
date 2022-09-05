terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
resource "github_repository" "git_repo" {
  name         = var.git_repo_name
  description  = var.git_repo_description
  homepage_url = var.git_repo_homepage_url
  visibility   = var.git_repo_visibility
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
data "github_actions_public_key" "git_repo_public_key" {
  repository = var.git_repo_name
}

resource "github_actions_secret" "git_secret_aws_access_key_id" {
  repository      = var.git_repo_name
  secret_name     = var.aws_access_key_id_name
  plaintext_value = var.aws_access_key_id_value
}

resource "github_actions_secret" "git_secret_aws_access_key" {
  repository      = var.git_repo_name
  secret_name     = var.aws_access_key_name
  plaintext_value = var.aws_access_key_value
}
