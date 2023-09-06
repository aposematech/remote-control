terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    # https://registry.terraform.io/providers/integrations/github/latest/docs
    github = {
      source  = "integrations/github"
      version = "~> 5.16.0"
    }
  }

  required_version = "~> 1.5.6"
}
