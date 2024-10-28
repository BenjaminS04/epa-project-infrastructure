output "target-iam_instance_profile" {
  value = aws_iam_instance_profile.target_ec2_instance_profile
}

output "monitor-iam_instance_profile" {
  value = aws_iam_instance_profile.monitor_ec2_instance_profile
}