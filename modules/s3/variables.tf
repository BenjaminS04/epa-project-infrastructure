variable "region" {
  description = "The AWS region where the S3 bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

variable "environment" {
  description = "Environment to deploy workload"
  default     = "dev"
  type        = string
  nullable    = false
}

