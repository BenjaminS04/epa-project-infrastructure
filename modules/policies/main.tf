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


//--- target app instance policy

# CloudWatch Agent Policy for target instance
resource "aws_iam_policy" "target_cloudwatch_agent_policy" {
  name = "target_cloudwatch_agent_policy"
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

# IAM Role for EC2 for target instance
resource "aws_iam_role" "target_ec2_service_role" {
  name = "monitor_EC2ServiceRole"

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

# Attach S3 Policy to the Role for target instance
resource "aws_iam_role_policy_attachment" "user_policy_attachment" {
  role       = aws_iam_role.target_ec2_service_role.name
  policy_arn = aws_iam_policy.user_s3_policy.arn
}

# Attach CloudWatch Agent Policy to the Role for target instance 
resource "aws_iam_role_policy_attachment" "target_cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.target_ec2_service_role.name
  policy_arn = aws_iam_policy.target_cloudwatch_agent_policy.arn
}

# IAM Instance Profile for EC2 for target instance
resource "aws_iam_instance_profile" "target_ec2_instance_profile" {
  name = "target-EC2InstanceProfile"
  role = aws_iam_role.target_ec2_service_role.name
}



//--- monitor app instance policy

# CloudWatch Agent Policy for monitor instance
resource "aws_iam_policy" "monitor_cloudwatch_agent_policy" {
  name = "monitor_cloudwatch_agent_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "cloudwatch:GetMetricData",
          "logs:GetLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect = "Allow",
        Resource = "*"
      },
    ]
  })
}

# IAM Role for EC2 for monitor instance
resource "aws_iam_role" "monitor_ec2_service_role" {
  name = "monitor_EC2ServiceRole"

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

# Attach S3 Policy to the Role for monitor instance
resource "aws_iam_role_policy_attachment" "user_policy_attachment" {
  role       = aws_iam_role.monitor_ec2_service_role.name
  policy_arn = aws_iam_policy.user_s3_policy.arn
}

# Attach CloudWatch Agent Policy to the Role for monitor instance 
resource "aws_iam_role_policy_attachment" "monitor_cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.monitor_ec2_service_role.name
  policy_arn = aws_iam_policy.monitor_cloudwatch_agent_policy.arn
}

# IAM Instance Profile for EC2 for monitor instance
resource "aws_iam_instance_profile" "monitor_ec2_instance_profile" {
  name = "monitor-EC2InstanceProfile"
  role = aws_iam_role.monitor_ec2_service_role.name
}