variable "git_repo_name" {
  description = "GitHub Repo Name"
  type        = string
}

variable "git_repo_description" {
  description = "GitHub Repo Description"
  type        = string
}

variable "git_repo_homepage_url" {
  description = "GitHub Repo Homepage URL"
  type        = string
}

variable "git_repo_topics" {
  description = "GitHub Repo Topics"
  type        = list(string)
}

variable "git_repo_visibility" {
  description = "GitHub Repo Visibility"
  type        = string
}

variable "aws_access_key_id_name" {
  description = "AWS Access Key ID - GitHub Actions Secret Name"
  type        = string
}

variable "aws_access_key_id_value" {
  description = "AWS Access Key ID - GitHub Actions Secret Value"
  type        = string
  sensitive   = true
}

variable "aws_access_key_name" {
  description = "AWS Access Key - GitHub Actions Secret Name"
  type        = string
}

variable "aws_access_key_value" {
  description = "AWS Access Key - GitHub Actions Secret Value"
  type        = string
  sensitive   = true
}

variable "aws_region_name" {
  description = "AWS Region - GitHub Actions Secret Name"
  type        = string
}

variable "aws_region_value" {
  description = "AWS Region - GitHub Actions Secret Value"
  type        = string
  sensitive   = true
}

variable "website_bucket_name" {
  description = "S3 Website Bucket - GitHub Actions Secret Name"
  type        = string
}

variable "website_bucket_value" {
  description = "S3 Bucket - GitHub Actions Secret Value"
  type        = string
  sensitive   = true
}
