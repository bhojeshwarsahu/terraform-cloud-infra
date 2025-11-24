resource "aws_security_group" "vpce_sg" {
  name        = "${var.environment}-vpce-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-vpce-sg"
    Environment = var.environment
  }
}

locals {
  endpoints = {
    ssm          = "ssm"
    ssmmessages  = "ssmmessages"
    ec2messages  = "ec2messages"
    ec2          = "ec2"
    ecr_api      = "ecr.api"
    ecr_dkr      = "ecr.dkr"
    sts          = "sts"
    logs         = "logs"
  }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = local.endpoints

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce_sg.id]
  
  tags = {
    Name = "${var.environment}-${each.key}-vpce"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  
  tags = {
    Name = "${var.environment}-s3-vpce"
  }
}