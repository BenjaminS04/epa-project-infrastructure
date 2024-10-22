locals {
  instances = {
    target = <<-EOF
      sudo sed -i -e 's/<h1>Welcome to nginx!/<h1>target/g' /var/www/html/index.nginx-debian.html
    EOF
    monitor = <<-EOF
      sudo sed -i -e 's/<h1>Welcome to nginx!/<h1>monitor/g' /var/www/html/index.nginx-debian.html
    EOF
  }
}