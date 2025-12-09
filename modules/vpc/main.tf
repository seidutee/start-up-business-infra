
##########################
#          VPC           #
##########################

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy

  tags = {
    Name = "${var.ResourcePrefix}-vpc"
  }
}

##########################
#   INTERNET GATEWAY     #
##########################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.ResourcePrefix}-igw"
  }
}

##########################
#      PUBLIC SUBNETS    #
##########################

resource "aws_subnet" "public_subnet" {
  for_each = { for idx, cidr in var.public_subnet_cidr : idx => cidr }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, each.key)
  map_public_ip_on_launch = var.public_ip_on_launch

  tags = {
    Name = "${var.ResourcePrefix}-PublicSubnet-${each.key + 1}"
  }
}

##########################
#      PRIVATE SUBNETS   #
##########################

resource "aws_subnet" "private_subnet" {
  for_each = { for idx, cidr in var.private_subnet_cidr : idx => cidr }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = element(var.availability_zones, each.key)

  tags = {
    Name = "${var.ResourcePrefix}-PrivateSubnet-${each.key + 1}"
  }
}

##########################
#   PUBLIC ROUTE TABLE   #
##########################

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.PublicRT_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.ResourcePrefix}-PublicRT"
  }
}

resource "aws_route_table_association" "PublicSubnetAssoc" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.PublicRT.id
}

##########################
# NAT GATEWAYS & ROUTING #
##########################

# Create one EIP per AZ (if enabled)
resource "aws_eip" "nat_eip" {
  for_each = var.create_nat_gateway ? aws_subnet.public_subnet : {}

  domain = "vpc"

  tags = {
    Name = "${var.ResourcePrefix}-nat-eip-${each.key}"
  }
}

# Create one NAT Gateway per AZ (linked to subnet & EIP)
resource "aws_nat_gateway" "nat_gw" {
  for_each = var.create_nat_gateway ? aws_subnet.public_subnet : {}

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.ResourcePrefix}-nat-gw-${each.key}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Create one private route table per AZ with NAT route
resource "aws_route_table" "private_rt" {
  for_each = var.create_nat_gateway ? aws_subnet.private_subnet : {}

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }

  tags = {
    Name = "${var.ResourcePrefix}-private-rt-${each.key}"
  }
}

# Associate each private subnet with its corresponding RT
resource "aws_route_table_association" "private_assoc" {
  for_each = var.create_nat_gateway ? aws_subnet.private_subnet : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
}
