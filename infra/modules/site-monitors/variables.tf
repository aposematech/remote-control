variable "registered_domain_name" {
  description = "Route 53 Registered Domain Name"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
  default     = ""
}

variable "ops_email_address" {
  description = "Operations Email Address"
  type        = string
  default     = ""
}

variable "status_codes" {
  description = "Default Alert Status Codes"
  type        = list(string)
  default     = ["204", "205", "206", "303", "400", "401", "403", "404", "405", "406", "408", "410", "413", "444", "429", "494", "495", "496", "499", "500", "501", "502", "503", "504", "505", "506", "507", "508", "509", "510", "511", "521", "522", "523", "524", "520", "598", "599"]
}

variable "status_page_subdomain" {
  description = "Better Uptime Status Page Subdomain"
  type        = string
  default     = ""
}
