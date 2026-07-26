############################################################
# VPC MODULE OUTPUTS
#
# These outputs are exported to the root module.
# Other modules (IAM, EKS, CloudWatch) will use them.
############################################################

############################################################
# VPC ID
############################################################

output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.main.id

}

############################################################
# Public Subnet IDs
############################################################

output "public_subnet_1_id" {

  description = "Public Subnet 1 ID"

  value = aws_subnet.public1.id

}

output "public_subnet_2_id" {

  description = "Public Subnet 2 ID"

  value = aws_subnet.public2.id

}

############################################################
# Private Subnet IDs
############################################################

output "private_subnet_1_id" {

  description = "Private Subnet 1 ID"

  value = aws_subnet.private1.id

}

output "private_subnet_2_id" {

  description = "Private Subnet 2 ID"

  value = aws_subnet.private2.id

}

############################################################
# Internet Gateway
############################################################

output "internet_gateway_id" {

  description = "Internet Gateway ID"

  value = aws_internet_gateway.igw.id

}

############################################################
# NAT Gateway
############################################################

output "nat_gateway_id" {

  description = "NAT Gateway ID"

  value = aws_nat_gateway.nat.id

}

############################################################
# Elastic IP
############################################################

output "nat_eip" {

  description = "Elastic IP used by NAT Gateway"

  value = aws_eip.nat.public_ip

}

############################################################
# Route Tables
############################################################

output "public_route_table_id" {

  description = "Public Route Table"

  value = aws_route_table.public.id

}

output "private_route_table_id" {

  description = "Private Route Table"

  value = aws_route_table.private.id

}