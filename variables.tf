variable "region" {
  default = "us-east-1"
  type    = string
}
variable "ami" {
  default = "ami-080e1f13689e07408"
  type    = string
}
variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "app-branch" {
  default = "feat/alerts" //"dev"
  type    = string
}

variable "app-repo" {
  default = "https://github.com/BenjaminS04/epa-project-app.git"
  type    = string
}

variable "environment" {
  description = "Environment to deploy workload"
  default     = "dev"
  type        = string
  nullable    = false
}

variable "vpn_ip" {
  description = "ip to limit access to instances to company ip/vpn"
  default     = " 195.50.119.196"
  type        = string
}

variable "bucket_name" {
  description = "name for log bucket"
  default     = "s3-bucket-bens-epa-logs"
  type        = string
}

variable "sns_arn" {
  description = "arn for sns"
  default     = "arn:aws:sns:us-east-1:267239224662:EC2-CPU-Alerts"

}




