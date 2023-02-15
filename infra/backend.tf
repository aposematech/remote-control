terraform {
  # https://www.terraform.io/language/settings/terraform-cloud
  cloud {
    organization = "djfav"
    workspaces {
      name = "demo-site"
    }
  }
}
