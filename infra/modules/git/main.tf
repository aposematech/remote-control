# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
resource "github_repository" "git_repo" {
  name         = var.git_repo_name
  description  = var.git_repo_description
  homepage_url = var.git_repo_homepage_url
  topics       = var.git_repo_topics
  visibility   = var.git_repo_visibility
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

resource "github_actions_secret" "git_secret_aws_region" {
  repository      = var.git_repo_name
  secret_name     = var.aws_region_name
  plaintext_value = var.aws_region_value
}

resource "github_actions_secret" "git_secret_website_bucket" {
  repository      = var.git_repo_name
  secret_name     = var.website_bucket_name
  plaintext_value = var.website_bucket_value
}
