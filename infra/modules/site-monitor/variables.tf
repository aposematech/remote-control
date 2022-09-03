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

variable "canary_script_bucket_name" {
  description = "CloudWatch Synthetics Canary Script - S3 Bucket Name"
  type        = string
  default     = ""
}

variable "canary_artifacts_bucket_name" {
  description = "CloudWatch Synthetics Canary Artifacts - S3 Bucket Name"
  type        = string
  default     = ""
}

variable "canary_name" {
  description = "CloudWatch Synthetics Canary Name"
  type        = string
  default     = ""
}

variable "canary_s3_key" {
  description = "CloudWatch Synthetics Canary S3 Key"
  type        = string
  default     = ""
}

variable "canary_schedule_expression" {
  description = "CloudWatch Synthetics Canary Schedule Expression"
  type        = string
  default     = ""
}

variable "canary_runtime_version" {
  description = "CloudWatch Synthetics Canary Runtime Version"
  type        = string
  default     = ""
}
