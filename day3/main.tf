# creating vpc 
resource "aws_vpc" "priya" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Manjuvpc"
    }
}
#create internet gateway 
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.priya.id
  tags = {
    Name = "manjuig"
  }
}
# create public subnets
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.priya.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    tags = {
      Name = "publicsubnet"
    }
}
#create private network
resource "aws_subnet" "private" {
    vpc_id =  aws_vpc.priya.id
    cidr_block = "10.0.1.0/24"
    tags = {
      name = "privatesubnet"
    }  
}
#create public route table and edit it
resource "aws_route_table" "publicrt" {
    vpc_id = aws_vpc.priya.id
    tags = {
        Name = "publicroutetable"
    }
    route{ 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }
    }
#create subnet association for publicroute table
resource "aws_route_table_association" "editroute" {
    route_table_id = aws_route_table.publicrt.id
    subnet_id = aws_subnet.public.id  
}
#create elastic ip 
resource "aws_eip" "elastic" {
    domain = "vpc"
}
#create nat gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.elastic.id
    subnet_id = aws_subnet.public.id
    tags ={
        Name = "natgateway"
    }
    }
# creating routetable to private (edit route to private routetable)
resource "aws_route_table" "privateroute" {
    vpc_id = aws_vpc.priya.id
    tags = {
      Name ="private route table"
    }
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
  }
#create subnet assocaiation for private route table
resource "aws_route_table_association" "private" {
    route_table_id = aws_route_table.privateroute.id
    subnet_id = aws_subnet.private.id
  }
# creating security group
resource "aws_security_group" "sg" {
    name = "allowalltraffic"
    vpc_id = aws_vpc.priya.id
    tags = {
      Name = "customSG"
    }
    ingress {
        description = "inbound traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}