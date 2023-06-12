
resource "aws_eip" "nat_eip" {
  
  vpc = true
  depends_on = [aws_internet_gateway.NAT-IGW]
  tags = {
    "name" = "nat_eip"
  }
}

resource "aws_nat_gateway" "terraform_nat" {

    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet-01.id
    tags = {
      "name" = "terraform_nat"
    }
  
}


