output "registered_domain_name" {
  value       = aws_route53domains_registered_domain.registered_domain.domain_name
  description = "Route 53 Registered Domain Name"
}

output "hosted_zone_id" {
  value       = aws_route53_zone.zone.zone_id
  description = "Route 53 Hosted Zone ID"
}
