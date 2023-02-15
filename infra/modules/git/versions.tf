terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.16.0"
    }
  }

  required_version = "~> 1.3.7"
}
