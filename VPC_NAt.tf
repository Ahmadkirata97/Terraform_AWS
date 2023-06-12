resource "aws_vpc" "vpc_forNat" {

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_classiclink = false
    tags = {
        name = "vpc_forNat"
    }
}

resource "aws_subnet" "public_subnet-01" {

    vpc_id = aws_vpc.vpc_forNat.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      "name" = "public_subnet-01"
    }
  
}


resource "aws_subnet" "private_subnet-01" {

    vpc_id = aws_vpc.vpc_forNat.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      "name" = "private_subnet-01"
    }
}

resource "aws_internet_gateway" "NAT-IGW" {

    vpc_id = aws_vpc.vpc_forNat.id
    tags = {
        name = "NAT-IGW"
    }
  
}

resource "aws_route_table" "public_route" {

    vpc_id = aws_vpc.vpc_forNat.id
    route {
        cidr_block = "10.0.1.0/24"
        gateway_id = aws_internet_gateway.NAT-IGW.id
    }

    tags = {
        name = "public Route"
    }
  
}

resource "aws_route_table" "private_route" {

    vpc_id = aws_vpc.vpc_forNat.id
    route {
        cidr_block = "10.0.2.0/24"
        gateway_id = aws_nat_gateway.terraform_nat.id
    }
    tags = {
        name = "private_route"
    }
}

resource "aws_route_table_association" "associate_with_public_subnets" {

    subnet_id = aws_subnet.public_subnet-01.id
    route_table_id = aws_route_table.public_route.id
  
}


resource "aws_route_table_association" "associate_with_private_subnets" {

    subnet_id = aws_subnet.private_subnet-01.id
    route_table_id = aws_route_table.private_route.id
  
}