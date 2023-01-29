variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "registered_domain_name" {
  description = "Route 53 Registered Domain Name"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted Zone ID"
  type        = string
}

variable "betteruptime_subdomain" {
  description = "Better Uptime Status Page Subdomain"
  type        = string
}

variable "custom_status_page_subdomain" {
  description = "Custom Status Page Subdomain"
  type        = string
}
