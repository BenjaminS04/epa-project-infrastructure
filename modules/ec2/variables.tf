variable "ami" {
  description = "AMI for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
}

variable "security_group_id" {
  description = "ID of the security group"
}

variable "subnet_id" {
  description = "ID of the subnet"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
}

# variable "user_password" {
#   description = "Password"
# }

variable "bucket_name" {
  description = "name of bucket"
}

variable "iam_instance_profile" {
  description = "ec2 instance iam"
}

variable "additional_user_data" {
  description = "aditional user data to append to user data script"
}