# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/25"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "ap-south-1a"
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = "ap-south-1a"
}

# Create a default route table for the VPC
resource "aws_route_table" "route-tb" {
  vpc_id = aws_vpc.vpc.id
}

# Create Inernet gateway ID
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# Create a route for the public subnet to allow internet access via the VPC's internet gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route-tb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate the public subnet with the default route table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route-tb.id
}

# Create a security group for the instance
resource "aws_security_group" "sg" {
  name_prefix = "assignment-sg"
  description = "Security group for Assignment"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
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
    Name    = "assignment-sg",
    purpose = "Assignment"
  }
}


# Create an EC2 instance in the public subnet
resource "aws_instance" "ec2" {
  ami             = "ami-067c21fb1979f0b27"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  key_name        = "ssh"
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = false
  }
  tags = {
    Name    = "assignment-ec2",
    purpose = "Assignment"
  }
}