variable "ops_email_address" {
  description = "Operations Team Email Address"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = ""
}

variable "aws_account_number" {
  description = "AWS Account Number"
  type        = string
  default     = ""
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID - GitHub Actions Secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_access_key" {
  description = "AWS Access Key - GitHub Actions Secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "statuscake_api_token" {
  description = "StatusCake API Token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "betteruptime_api_token" {
  description = "Better Uptime API Token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "checkly_account_id" {
  description = "Checkly Account ID"
  type        = string
  default     = ""
}

variable "checkly_api_key" {
  description = "Checkly API Key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "new_relic_account_id" {
  description = "New Relic Account ID"
  type        = string
  default     = ""
}

variable "new_relic_api_key" {
  description = "New Relic API Key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "rew_relic_region" {
  description = "New Relic Region"
  type        = string
  default     = ""
}
