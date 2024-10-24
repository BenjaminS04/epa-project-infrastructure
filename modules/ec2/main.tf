
resource "aws_instance" "ec2" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = "EC2InstanceProfile"
   #user data used to run script upon ec2 initialisation

  user_data = <<-EOF
              #!/bin/bash

              
              # gets cloudwatch logging dependancies

              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i -E ./amazon-cloudwatch-agent.deb
              
              
              
              
              

              ${var.additional_user_data}
              EOF
  

  # adds security group and subnet
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  tags = {
    # names instance
    Name = "${var.instance_name}"
  }
}