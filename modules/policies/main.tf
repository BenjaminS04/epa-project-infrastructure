# User S3 Policy
resource "aws_iam_policy" "user_s3_policy" {
  name   = "UserS3AccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}

# CloudWatch Agent Policy
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name = "cloudwatch_agent_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect = "Allow",
        Resource = "*"
      },
    ]
  })
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_service_role" {
  name = "EC2ServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      },
    ]
  })
}

# Attach S3 Policy to the Role
resource "aws_iam_role_policy_attachment" "user_policy_attachment" {
  role       = aws_iam_role.ec2_service_role.name
  policy_arn = aws_iam_policy.user_s3_policy.arn
}

# Attach CloudWatch Agent Policy to the Role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.ec2_service_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_service_role.name
}