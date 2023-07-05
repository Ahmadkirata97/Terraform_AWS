resource "aws_security_group" "terraform_sg_for_LB" {
  
  description = "terraform _sg"
  vpc_id = aws_vpc.vpc_forNat.id
  name = "terraform_LB_sg"

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
    "name" = "terraform_LB_sg"
  }

}