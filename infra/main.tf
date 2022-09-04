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
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "~> 2.0.0"
    }
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.3.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = var.aws_region
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs
provider "statuscake" {
  api_token = var.statuscake_api_token
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs
provider "betteruptime" {
  api_token = var.betteruptime_api_token
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

module "site_monitors" {
  source                 = "./modules/site-monitors"
  registered_domain_name = module.static_website.registered_domain_name
  ops_email_address      = var.ops_email_address
  betteruptime_subdomain = "djfav"
}
