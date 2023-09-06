terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
    }
  }

  required_version = "~> 1.5.6"
}
