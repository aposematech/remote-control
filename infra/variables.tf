variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "registered_domain_name" {
  description = "Route 53 registered domain name"
  type        = string
  default     = ""
}

variable "default_page" {
  description = "Static website default page"
  type        = string
  default     = "index.html"
}
