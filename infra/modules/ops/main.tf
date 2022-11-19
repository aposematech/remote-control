terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.ops_email_address
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "canary_artifacts_bucket" {
  bucket = "${var.registered_domain_name}-canary-artifacts"
}

resource "aws_s3_bucket" "canary_scripts_bucket" {
  bucket = "${var.registered_domain_name}-canary-scripts"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "canary_role_permissions_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.canary_scripts_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.canary_artifacts_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.canary_artifacts_bucket.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_number}:*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_number}:log-group:/aws/lambda/cwsyn-${var.sns_topic_name}-*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "xray:PutTraceSegments",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["CloudWatchSynthetics"]
    }
    resources = ["*"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "canary_role_permissions" {
  name   = "${var.sns_topic_name}-canary-role-permissions"
  policy = data.aws_iam_policy_document.canary_role_permissions_policy_document.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "canary_assume_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "canary_role" {
  name               = "${var.sns_topic_name}-canary-role"
  assume_role_policy = data.aws_iam_policy_document.canary_assume_role_policy_document.json
  managed_policy_arns = [
    aws_iam_policy.canary_role_permissions.arn,
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary
resource "aws_synthetics_canary" "canary" {
  name                 = var.sns_topic_name
  artifact_s3_location = "s3://${aws_s3_bucket.canary_artifacts_bucket.id}"
  execution_role_arn   = aws_iam_role.canary_role.arn
  s3_bucket            = aws_s3_bucket.canary_scripts_bucket.id
  s3_key               = "canary.zip"
  handler              = "canary.handler"
  runtime_version      = "syn-python-selenium-1.3"
  delete_lambda        = true

  run_config {
    environment_variables = {
      URL = "https://${var.registered_domain_name}"
    }
  }

  schedule {
    expression = var.canary_cron
  }
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs/resources/betteruptime_monitor
resource "betteruptime_monitor" "monitor" {
  monitor_type = "status"
  url          = "https://${var.registered_domain_name}"
  email        = true
  paused       = false

  check_frequency     = 180
  request_timeout     = 15
  confirmation_period = 3
  regions             = ["us", "eu", "as", "au"]

  domain_expiration = 30
  verify_ssl        = true
  ssl_expiration    = 30
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs/resources/betteruptime_status_page
resource "betteruptime_status_page" "status_page" {
  company_name  = var.registered_domain_name
  company_url   = "https://${var.registered_domain_name}"
  subdomain     = var.betteruptime_subdomain
  custom_domain = "${var.custom_status_page_subdomain}.${var.registered_domain_name}"
  timezone      = "Central Time (US & Canada)"
}

# https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs/resources/betteruptime_status_page_resource
resource "betteruptime_status_page_resource" "status_page_resource" {
  public_name    = var.registered_domain_name
  resource_id    = betteruptime_monitor.monitor.id
  resource_type  = "Monitor"
  status_page_id = betteruptime_status_page.status_page.id
  history        = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "status_page_record" {
  zone_id = var.hosted_zone_id
  name    = var.custom_status_page_subdomain
  type    = "CNAME"
  records = ["statuspage.betteruptime.com"]
  ttl     = 60
}

# https://registry.terraform.io/providers/checkly/checkly/latest/docs/resources/check
resource "checkly_check" "browser_check" {
  name                      = var.registered_domain_name
  type                      = "BROWSER"
  activated                 = true
  should_fail               = false
  frequency                 = 15
  double_check              = true
  use_global_alert_settings = true

  locations = [
    var.aws_region
  ]

  runtime_id = "2022.02"

  script = <<EOT
const { chromium } = require('playwright')
async function run () {
  const browser = await chromium.launch()
  const page = await browser.newPage()

  const response = await page.goto('https://${var.registered_domain_name}')

  if (response.status() > 399) {
    throw new Error(`Failed with response code $${response.status()}`)
  }

  await page.screenshot({ path: 'screenshot.jpg' })

  await page.close()
  await browser.close()
}
run()
EOT
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

# https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/synthetics_monitor
resource "newrelic_synthetics_monitor" "monitor" {
  name              = "${var.registered_domain_name}-monitor"
  type              = "SIMPLE"
  uri               = "https://${var.registered_domain_name}"
  validation_string = var.registered_domain_name
  verify_ssl        = true
  locations_public  = ["US_EAST_1"]
  period            = "EVERY_15_MINUTES"
  status            = "ENABLED"
}

# https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/synthetics_monitor_cert_check
resource "newrelic_synthetics_cert_check_monitor" "cert_check_monitor" {
  name                   = "${var.registered_domain_name}-cert-check-monitor"
  domain                 = var.registered_domain_name
  locations_public       = ["US_EAST_1"]
  certificate_expiration = "30"
  period                 = "EVERY_DAY"
  status                 = "ENABLED"
}
