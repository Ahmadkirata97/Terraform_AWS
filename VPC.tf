provider "aws" {
    region = "us-east-1"
  
}
resource "aws_vpc" "terraform_VPC" {

    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        name = "Terraform_VPC"
    }
}

resource "aws_subnet" "terraform_VPC_Public_Subnet" {

    vpc_id = aws_vpc.terraform_VPC.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = ""
    tags = {
        name = "terraform_VPC_Public_Subnet"
    }
}

resource "aws_subnet" "terraform_VPC_Public_Subnet-1" {

    vpc_id = aws_vpc.terraform_VPC.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = ""
    tags = {
        name = "terraform_VPC_Public_Subnet-1"
    }
}

resource "aws_internet_gateway" "Terraform_VPC_gw1" {

    vpc_id = aws_vpc.terraform_VPC.id
    tags = {
      "name" = "igw1"
    }

  
}
resource "aws_route_table" "terraform_route_table-public" {
  
  vpc_id = aws_vpc.terraform_VPC.id
  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.Terraform_VPC_gw1.id
  }

  tags = {
    name = "public_route"
  }

}

resource "aws_route_table" "terraform_route_table_private" {
  
  vpc_id = aws_vpc.terraform_VPC.id
  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = aws_nat.terraform_nat.id
  }
}

resource "aws_route_table_association" "associate_with_public_subnet" { 

    subnet_id = aws_subnet.terraform_VPC_Public_Subnet.id
    route_table_id = aws_route_table.terraform_route_table-public.id
  
}

resource "aws_route_table_association" "associate_with_public_subnet-1" {

    subnet_id = aws_subnet.terraform_VPC_Public_Subnet-1.id
    route_table_id = aws_route_table.terraform_route_table-public.id
  
}

resource "aws_instance" "terraform_instance" {

    instance_type = "t2.micro"
    ami = "ami-02396cdd13e9a1257"
    key_name = "privatekey"
    subnet_id = aws_subnet.terraform_VPC_Public_Subnet.id
    tags = {
        name = "terraform_instance"
    }
    
  
}