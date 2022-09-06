variable "git_repo_name" {
  description = "GitHub Repo Name"
  type        = string
  default     = ""
}

variable "git_repo_description" {
  description = "GitHub Description"
  type        = string
  default     = ""
}

variable "git_repo_homepage_url" {
  description = "GitHub Repo Homepage URL"
  type        = string
  default     = ""
}

variable "git_repo_visibility" {
  description = "GitHub Repo Visibility"
  type        = string
  default     = ""
}

variable "aws_access_key_id_name" {
  description = "AWS Access Key ID - GitHub Actions Secret Name"
  type        = string
  default     = ""
}

variable "aws_access_key_id_value" {
  description = "AWS Access Key ID - GitHub Actions Secret Value"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_access_key_name" {
  description = "AWS Access Key - GitHub Actions Secret Name"
  type        = string
  default     = ""
}

variable "aws_access_key_value" {
  description = "AWS Access Key - GitHub Actions Secret Value"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_region_name" {
  description = "AWS Region - GitHub Actions Secret Name"
  type        = string
  default     = ""
}

variable "aws_region_value" {
  description = "AWS Region - GitHub Actions Secret Value"
  type        = string
  default     = ""
  sensitive   = true
}

variable "bucket_name" {
  description = "S3 Bucket - GitHub Actions Secret Name"
  type        = string
  default     = ""
}

variable "bucket_value" {
  description = "S3 Bucket - GitHub Actions Secret Value"
  type        = string
  default     = ""
  sensitive   = true
}
