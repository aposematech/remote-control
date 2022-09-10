terraform {
  # https://www.terraform.io/language/providers/requirements
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
resource "aws_route53domains_registered_domain" "registered_domain" {
  domain_name = var.registered_domain_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "zone" {
  name = var.registered_domain_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.registered_domain_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block
resource "aws_s3_account_public_access_block" "account_public_access_block" {
  block_public_acls   = false
  block_public_policy = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  bucket              = aws_s3_bucket.website_bucket.bucket
  block_public_acls   = false
  block_public_policy = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "website_bucket_policy_document" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*",
    ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = data.aws_iam_policy_document.website_bucket_policy_document.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = var.default_page
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.registered_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_record : record.fqdn]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = var.registered_domain_name
  }

  enabled             = true
  default_root_object = var.default_page

  aliases = ["${var.registered_domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.registered_domain_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "cloudfront_distribution_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.registered_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
