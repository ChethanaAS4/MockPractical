provider "aws" {
        region = "ap-south-1"
}

resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MockVPC"
  }

}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "MockPublicSubnet1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "MockPublicSubnet2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "MockPrivateSubnet1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "MockPrivateSubnet2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "MockIGW"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MockPublicRT"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "MockPrivateRT"
  }
}


resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.VPC.id

  tags = {
    Name = "security_allow_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ingress" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ingress_ipv6" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
