# user data for the instances
locals {
  instances = {
    target = <<-EOF
    
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
      sudo sed -i -e 's/<h1>Welcome to nginx!/<h1>target/g' /var/www/html/index.nginx-debian.html
    EOF
    
    
    
    
    
    
    monitor = <<-EOF

      # restarts cloudwatch agent using new config

      /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

      
      
      # updates and upgrades instance

      sudo apt update
      sudo apt upgrade -y

      sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
      sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

      
      
      # install nginx

      sudo apt install nginx -y

      
      
      # install git
      
      sudo apt install -y git
      
      
      
      # install node

      sudo apt-get install -y nodejs npm


      
      # install express

      sudo npm install -g express

      
      
      # clone app repo from specified branch
      
      sudo git clone --branch ${var.app-branch} ${var.app-repo} /var/www/monitorapp



      # create server js folder and move server js file from static files location

      sudo mkdir ~/ec2-metrics-app-servjs
      sudo cd ~/ec2-metrics-app-servjs
      sudo npm init -y
      sudo npm install express aws-sdk body-parser
      sudo mv /var/www/monitorapp/server.js ~/ec2-metrics-app-servjs


      
      # set directory permissions
      
      sudo chown -R www-data:www-data /var/www/monitorapp
      sudo chmod -R 755 /var/www/monitorapp

      
      
      # configure nginx
      
      NGINX_CONFIG="/etc/nginx/sites-available/monitorapp"
      cat << 'EOL' | sudo tee $NGINX_CONFIG > /dev/null
      server {
        listen 80;
        server_name _;

        root /var/www/monitorapp;
        index html/index.html;

        location / {
            try_files $uri $uri/ /html/index.html;
        }

        location /css/ {
            alias /var/www/monitorapp/css/;
        }

        location /js/ {
            alias /var/www/monitorapp/js/;
        }

        #proxy api requests to node server
        location /api/ {
          proxy_pass http://localhost:3000;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
      }
      EOL

      sudo ln -s $NGINX_CONFIG /etc/nginx/sites-enabled/



      # verifies node server running

      node server.js

      
      
      # remove default nginx config to avoid conflicts
      
      sudo rm /etc/nginx/sites-enabled/default

      
      
      # test nginx config
      
      sudo nginx -t

      
      
      # reload nginx 
      
      sudo systemctl reload nginx

      EOF
  }
}