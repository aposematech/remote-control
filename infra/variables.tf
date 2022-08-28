variable "registered_domain_name" {
  description = "Existing Route 53 registered domain name"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = ""
}

variable "default_page" {
  description = "Static website default page"
  type        = string
  default     = "index.html"
}
