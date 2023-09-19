import {
  to = aws_s3_bucket.website_bucket
  id = "djfav.ninja"
}

module "git" {
  source                  = "./modules/git"
  git_repo_name           = terraform.workspace
  git_repo_description    = var.git_repo_description
  git_repo_homepage_url   = "https://${module.web.registered_domain_name}"
  git_repo_topics         = ["canvas", "demo"]
  git_repo_visibility     = var.git_repo_visibility
  aws_access_key_id_name  = "AWS_ACCESS_KEY_ID"
  aws_access_key_id_value = var.aws_access_key_id
  aws_access_key_name     = "AWS_SECRET_ACCESS_KEY"
  aws_access_key_value    = var.aws_access_key
  aws_region_name         = "AWS_REGION"
  aws_region_value        = var.aws_region
  website_bucket_name     = "WEBSITE_BUCKET_NAME"
  website_bucket_value    = module.web.website_bucket_name
}

module "web" {
  source                 = "./modules/web"
  registered_domain_name = var.registered_domain_name
  default_page           = var.default_page
}

module "ops" {
  source                       = "./modules/ops"
  aws_region                   = var.aws_region
  registered_domain_name       = module.web.registered_domain_name
  hosted_zone_id               = module.web.hosted_zone_id
  betteruptime_subdomain       = var.betteruptime_subdomain
  custom_status_page_subdomain = var.custom_status_page_subdomain
}
