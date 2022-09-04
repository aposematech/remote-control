terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
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

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs/resources/contact_group
resource "statuscake_contact_group" "ops_contact_group" {
  name = var.registered_domain_name

  email_addresses = [
    var.ops_email_address,
  ]
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs/resources/uptime_check
resource "statuscake_uptime_check" "uptime_check" {
  name           = var.registered_domain_name
  check_interval = 300
  confirmation   = 3
  trigger_rate   = 5
  paused         = false

  contact_groups = [
    statuscake_contact_group.ops_contact_group.id
  ]

  http_check {
    timeout      = 15
    user_agent   = "StatusCake Uptime Check"
    validate_ssl = true

    status_codes = var.status_codes
  }

  monitored_resource {
    address = "https://${var.registered_domain_name}"
  }
}

# https://registry.terraform.io/providers/StatusCakeDev/statuscake/latest/docs/resources/ssl_check
resource "statuscake_ssl_check" "ssl_check" {
  check_interval = 86400
  user_agent     = "StatusCake SSL Check"
  paused         = false

  contact_groups = [
    statuscake_contact_group.ops_contact_group.id
  ]

  alert_config {
    alert_at = [1, 7, 30]

    on_reminder = true
    on_expiry   = true
    on_broken   = false
    on_mixed    = false
  }

  monitored_resource {
    address = "https://${var.registered_domain_name}"
  }
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs/resources/betteruptime_monitor
resource "betteruptime_monitor" "monitor" {
  monitor_type = "status"
  url          = "https://${var.registered_domain_name}"
  email        = true
  paused       = false

  check_frequency     = 5
  request_timeout     = 15
  confirmation_period = 3
  regions             = ["us", "eu", "as", "au"]

  domain_expiration = 30
  verify_ssl        = true
  ssl_expiration    = 30
}
