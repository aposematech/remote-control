terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
    }
    # https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.3.19"
    }
    # https://registry.terraform.io/providers/checkly/checkly/latest/docs
    checkly = {
      source  = "checkly/checkly"
      version = "~> 1.6.3"
    }
  }

  required_version = "~> 1.5.6"
}
