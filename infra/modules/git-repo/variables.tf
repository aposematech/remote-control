variable "git_repo_name" {
  description = "GitHub Name"
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
