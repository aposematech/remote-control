# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "canary_script_bucket" {
  bucket = var.canary_script_bucket_name
}

resource "aws_s3_bucket" "canary_artifacts_bucket" {
  bucket = var.canary_artifacts_bucket_name
}
