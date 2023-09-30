resource "aws_vpc" "master-vpc" {
    cidr_block = "10.0.0.0/16" # Change your desire IP_range
    instance_tenancy = "default"
    
    tags = {
      Name = "myvpc" # change as you wish
    }
    
  
}

resource "aws_subnet" "Subnet1" {   #public subnet1 creation
    vpc_id = aws_vpc.master-vpc.id
    cidr_block = "10.0.0.0/24"    # Change your desire IP_range
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet1"
    }
  
}

resource "aws_subnet" "Subnet2" {   #public subnet2 creation
    vpc_id = aws_vpc.master-vpc.id
    cidr_block = "10.0.1.0/24"      # Change your desire IP_range
    availability_zone = "ap-southeast-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet2"
    }
  
}

resource "aws_subnet" "Subnet3" {    #public subnet3 creation
    vpc_id = aws_vpc.master-vpc.id
    cidr_block = "10.0.2.0/24"   # Change your desire IP_range
    availability_zone = "ap-southeast-1c"  
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet3"
    }
  
}

resource "aws_route_table" "RT-NEW" {   # RT creation
    vpc_id = aws_vpc.master-vpc.id
    tags = {
      Name = "RT-NEW"
    }
  
}

resource "aws_route_table_association" "subnet1Associate" {
    route_table_id = aws_route_table.RT-NEW.id
    subnet_id = aws_subnet.Subnet1.id
  
}

resource "aws_route_table_association" "subnet2Associate" {
    route_table_id = aws_route_table.RT-NEW.id
    subnet_id = aws_subnet.Subnet2.id
  
}

resource "aws_route_table_association" "subnet3Associate" {
    route_table_id = aws_route_table.RT-NEW.id
    subnet_id = aws_subnet.Subnet3.id
  
}

resource "aws_internet_gateway" "IGW-NEW" {
    vpc_id = aws_vpc.master-vpc.id
    tags = {
      Name = "IGW-NEW"
    }
  
}

resource "aws_route" "WAN" {
    route_table_id = aws_route_table.RT-NEW.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-NEW.id
    
  
}

resource "aws_instance" "web-server" {
  ami = "ami-0eeadc4ab092fef70"
  subnet_id = aws_subnet.Subnet1.id
  key_name = "terraform-key"
  instance_type = "t2.micro"
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = "sg-0d2e2b08e527be13a"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1
  ip_protocol = "all"
  to_port = -1


}
