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
      version = "~> 4.31.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.3.12"
    }
    checkly = {
      source  = "checkly/checkly"
      version = "~> 1.4.3"
    }
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "~> 2.0.3"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.1.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {
  # export GITHUB_TOKEN
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = var.aws_region
  # export AWS_ACCESS_KEY_ID
  # export AWS_SECRET_ACCESS_KEY

  default_tags {
    tags = {
      Terraform = "true"
      Workspace = terraform.workspace
    }
  }
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs
provider "betteruptime" {
  api_token = var.betteruptime_api_token
}

# https://registry.terraform.io/providers/checkly/checkly/latest/docs
provider "checkly" {
  api_key    = var.checkly_api_key
  account_id = var.checkly_account_id
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs
provider "statuscake" {
  api_token = var.statuscake_api_token
}

# https://registry.terraform.io/providers/newrelic/newrelic/latest/docs
provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key    = var.new_relic_api_key
  region     = var.rew_relic_region
}

module "git" {
  source                  = "./modules/git"
  git_repo_name           = terraform.workspace
  git_repo_description    = var.git_repo_description
  git_repo_homepage_url   = "https://${var.registered_domain_name}"
  git_repo_visibility     = var.git_repo_visibility
  aws_access_key_id_name  = "AWS_ACCESS_KEY_ID"
  aws_access_key_id_value = var.aws_access_key_id
  aws_access_key_name     = "AWS_SECRET_ACCESS_KEY"
  aws_access_key_value    = var.aws_access_key
  aws_region_name         = "AWS_REGION"
  aws_region_value        = var.aws_region
  bucket_name             = "BUCKET_NAME"
  bucket_value            = var.registered_domain_name
}

module "web" {
  source                 = "./modules/web"
  registered_domain_name = var.registered_domain_name
  default_page           = var.default_page
}

module "ops" {
  source                       = "./modules/ops"
  sns_topic_name               = module.git.git_repo_name
  ops_email_address            = var.ops_email_address
  registered_domain_name       = module.web.registered_domain_name
  aws_account_number           = var.aws_account_number
  aws_region                   = var.aws_region
  canary_cron                  = var.canary_cron
  hosted_zone_id               = module.web.hosted_zone_id
  betteruptime_subdomain       = var.betteruptime_subdomain
  custom_status_page_subdomain = var.custom_status_page_subdomain
}
