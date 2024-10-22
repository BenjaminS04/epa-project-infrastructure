
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
              
              
              
              
              # creates cloudwatch config file for sending logs to cloudwatch

              cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOL'
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "syslog",
                          "log_stream_name": "{instance_id}-syslog"
                        },
                        {
                          "file_path": "/var/log/auth.log",
                          "log_group_name": "auth-log",
                          "log_stream_name": "{instance_id}-auth"
                        },
                        {
                          "file_path": "/var/log/cloud-init-output.log",
                          "log_group_name": "cloud-init-output",
                          "log_stream_name": "{instance_id}-cloud-init-output",
                          "timestamp_format": "%b %d %H:%M:%S"
                        }
                      ]
                    }
                  }
                }
              }
              EOL


              
              # restarts cloudwatch agent using new config

              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

              
              
              
              
              # updates and upgrades instance
              
              sudo apt update
              sudo apt upgrade -y && sudo apt install -y
              sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
              sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf
              

              
              # install nginx

              sudo apt install nginx -y
              #nginx -t

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