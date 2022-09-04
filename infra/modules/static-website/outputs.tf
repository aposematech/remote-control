output "registered_domain_name" {
  value       = aws_route53domains_registered_domain.registered_domain.domain_name
  description = "Route 53 Registered Domain Name"
}
