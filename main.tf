provider "aws" {      #making resources in Singapore
  region  = "ap-southeast-1"
}

resource "aws_key_pair" "key_pair" {
  key_name = "mynewkeypair"
  public_key = "${file("/home/pawan/.ssh/id_rsa.pub")}"
  
}

resource "aws_instance" "web_server" {      #making a free-tier ubuntu vm
  ami           = "ami-0a72af05d27b49ccb"
  instance_type = "t2.micro"
  key_name      = "mynewkeypair"  

  tags = {
    Name = "WebServerInstance"
  }

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
}

#adding firewall/security_group rules for ssh,http and outgoing traffic
resource "aws_security_group" "web_server_sg" {    
  name_prefix = "web_server_sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_instance" "web_server_data" {
  instance_id = aws_instance.web_server.id
}

output "public_ip" {    #displaying the public ip of the server on terminal
  value = data.aws_instance.web_server_data.public_ip
}
