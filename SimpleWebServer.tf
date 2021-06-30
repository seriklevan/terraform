#..............................................................................
# My Terraform
#
#Build WebServer during Bootstrap
#
#Made by Serhii Tsybulko
#
#..............................................................................
provider "aws" {

  region = "eu-central-1"
}

resource "aws_instance" "My_WebServer" {

  ami                    = "ami-089b5384aac360007"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = <<EOF
  #!/bin/bash
  yum -y update
  yum -y install httpd
  myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>WebServer With IP: $myip</h2><br>Built by Terraform!" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF

  tags = {
    Name  = "Web Server Buils by Terraform"
    Owner = "Seriklevan"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "Test WebServer Security Security Group1"
  description = "My First Sucurity Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Test Web Server SecurityGroup1"
    Owner = "Seriklevan"
  }
}
