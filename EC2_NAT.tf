resource "aws_security_group" "terraform_sg" {
  
  description = "terraform _sg"
  vpc_id = aws_vpc.vpc_forNat.id
  name = "terraform_private_sg"
  ingress {

    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22    
    to_port = 22
  }

    ingress {

    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080    
    to_port = 8080
  }

    ingress {

    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443   
    to_port = 443
  }

    egress {

    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0    
    to_port = 0
  }

  tags = {
    "name" = "terraform_sg"
  }

}

resource "aws_instance" "terraform_public_instance" {
  
  ami = "ami-02396cdd13e9a1257"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id = aws_subnet.public_subnet-01.id
  key_name = "privatekey"
  count = 1
  associate_public_ip_address = false
  tags = {
    name = "terraform_public_instance"
  }
}

resource "aws_instance" "terraform_private_instance" {
  
  ami = "ami-02396cdd13e9a1257"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id = aws_subnet.private_subnet-01.id
  key_name = "privatekey"
  count = 1
  associate_public_ip_address = false
  tags = {
    name = "terraform_private_subnet"
  }
}