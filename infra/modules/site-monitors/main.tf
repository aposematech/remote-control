terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "~> 2.0.0"
    }
  }
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs/resources/contact_group
resource "statuscake_contact_group" "ops_contact_group" {
  name     = "${terraform.workspace}-ops"
  ping_url = "https://${var.registered_domain_name}"

  email_addresses = [
    var.ops_email_address,
  ]
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs/resources/uptime_check
resource "statuscake_uptime_check" "uptime_check" {
  name           = "${terraform.workspace}-uptime-check"
  check_interval = 300
  confirmation   = 1
  paused         = true

  contact_groups = [
    statuscake_contact_group.ops_contact_group.id
  ]

  http_check {
    timeout      = 15
    validate_ssl = true

    status_codes = [
      "403",
      "404",
    ]
  }

  monitored_resource {
    address = "https://${var.registered_domain_name}"
  }

  regions = [
    "chicago",
  ]
}

resource "statuscake_ssl_check" "ssl_check" {
  check_interval = 86400
  paused         = true

  contact_groups = [
    statuscake_contact_group.ops_contact_group.id
  ]

  alert_config {
    alert_at = [1, 7, 30]

    on_reminder = true
    on_expiry   = true
    on_broken   = true
    on_mixed    = true
  }

  monitored_resource {
    address = "https://${var.registered_domain_name}"
  }
}
