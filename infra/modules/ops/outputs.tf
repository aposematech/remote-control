output "canary_scripts_bucket_name" {
  value       = aws_s3_bucket.canary_scripts_bucket.id
  description = "S3 Canary Scripts Bucket Name"
}