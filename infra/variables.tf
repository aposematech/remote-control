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

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "registered_domain_name" {
  description = "Route 53 registered domain name"
  type        = string
  default     = "djfav.ninja"
}

variable "default_page" {
  description = "Static website default page"
  type        = string
  default     = "index.html"
}
