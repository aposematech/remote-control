variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
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

variable "ops_email_address" {
  description = "Operations Team Email Address"
  type        = string
  default     = ""
}
