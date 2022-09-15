output "registered_domain_name" {
  value       = data.aws_route53_zone.zone.name
  description = "Route 53 Registered Domain Name"
}

output "hosted_zone_id" {
  value       = data.aws_route53_zone.zone.zone_id
  description = "Route 53 Hosted Zone ID"
}
