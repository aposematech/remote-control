variable "git_repo_description" {
  description = "GitHub Repo Description"
  type        = string
}

variable "git_repo_visibility" {
  description = "GitHub Repo Visibility"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_account_number" {
  description = "AWS Account Number"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID - GitHub Actions Secret"
  type        = string
  sensitive   = true
}

variable "aws_access_key" {
  description = "AWS Access Key - GitHub Actions Secret"
  type        = string
  sensitive   = true
}

variable "registered_domain_name" {
  description = "Route 53 Registered Domain Name"
  type        = string
}

variable "default_page" {
  description = "Static Website Default Page"
  type        = string
}

variable "betteruptime_api_token" {
  description = "Better Uptime API Token"
  type        = string
  sensitive   = true
}

variable "betteruptime_subdomain" {
  description = "Better Uptime Status Page Subdomain"
  type        = string
}

variable "custom_status_page_subdomain" {
  description = "Custom Status Page Subdomain"
  type        = string
}

variable "checkly_account_id" {
  description = "Checkly Account ID"
  type        = string
}

variable "checkly_api_key" {
  description = "Checkly API Key"
  type        = string
  sensitive   = true
}

variable "statuscake_api_token" {
  description = "StatusCake API Token"
  type        = string
  sensitive   = true
}

variable "ops_email_address" {
  description = "Operations Team Email Address"
  type        = string
}

variable "new_relic_account_id" {
  description = "New Relic Account ID"
  type        = string
}

variable "new_relic_api_key" {
  description = "New Relic API Key"
  type        = string
  sensitive   = true
}

variable "rew_relic_region" {
  description = "New Relic Region"
  type        = string
}
