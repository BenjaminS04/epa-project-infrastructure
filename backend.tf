terraform {
  backend "s3" {
    bucket  = "epa-backend-terraform-remote-states" # Replace with your S3 bucket name
    key     = "/${var.environment}-terraform state" # Path within the bucket to store the state file
    region  = var.region                            # AWS region of the bucket
    encrypt = true                                  # Encrypt state file at rest
  }
}

provider "aws" {
  region = var.region
}