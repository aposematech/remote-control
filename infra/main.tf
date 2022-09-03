terraform {
  # https://www.terraform.io/language/settings/terraform-cloud
  cloud {
    organization = "djfav"
    workspaces {
      name = "demo-site"
    }
  }

  # https://www.terraform.io/language/providers/requirements
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = var.aws_region
}

module "git_repo" {
  source                  = "./modules/git-repo"
  git_repo_description    = "Static website demo"
  git_repo_homepage_url   = "https://djfav.ninja"
  git_repo_visibility     = "public"
  aws_access_key_id_name  = "AWS_ACCESS_KEY_ID"
  aws_access_key_id_value = var.aws_access_key_id
  aws_access_key_name     = "AWS_SECRET_ACCESS_KEY"
  aws_access_key_value    = var.aws_access_key
}

module "static_website" {
  source                 = "./modules/static-website"
  registered_domain_name = "djfav.ninja"
  default_page           = "index.html"
}

module "site_monitor" {
  source                       = "./modules/site-monitor"
  aws_region                   = var.aws_region
  aws_account_number           = var.aws_account_number
  canary_name                  = "djfav-dot-ninja"
  canary_script_bucket_name    = "djfav.ninja-canary-script"
  canary_s3_key                = "canary.zip"
  canary_artifacts_bucket_name = "djfav.ninja-canary-artifacts"
  canary_schedule_expression   = "rate(0 hour)"
  canary_handler               = "canary.handler"
  canary_runtime_version       = "syn-python-selenium-1.3"
}
