output "bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_name" {
  description = "the name for the bucket"
  value       = var.bucket_name
}

output "state_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "state_bucket_name" {
  description = "the name for the bucket"
  value       = "epa-backend-terraform-remote-states"
}