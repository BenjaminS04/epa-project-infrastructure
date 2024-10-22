# Defines the S3 bucket resource and uses tags to name it
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  

  tags = {
    Name = var.bucket_name

  }
}

# creates acl for the s3 bucket specified
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.bucket.id
  
  # Blocks the use of public ACLs on this S3 bucket.
  block_public_acls       = true
  
  # Prevents the bucket from having public bucket policies.
  block_public_policy     = true
  
  # Ignores any public ACLs on the bucket's objects.
  ignore_public_acls      = true
  
  # Restricts public bucket policies from allowing cross-account access unless explicitly authorized.
  restrict_public_buckets = true  
}