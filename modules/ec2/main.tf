# ============================================
# EC2 Module - Web and App Tier Instances
# ============================================

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "${var.sg_name}-${var.environment}"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]  # Reference from ALB module
  }

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.sg_name}-${var.environment}"
    Environment = var.environment
  }
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Web Tier EC2 Instances
resource "aws_instance" "web_tier" {
  count           = var.web_tier_instance_count
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = var.public_subnets[count.index % length(var.public_subnets)]
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = base64encode("#!/bin/bash\necho 'Web Server Running'")

  tags = {
    Name = "${var.environment}-web-${count.index + 1}"
    Tier = "web"
  }
}

# App Tier EC2 Instances
resource "aws_instance" "app_tier" {
  count           = var.app_tier_instance_count
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = var.private_subnets[count.index % length(var.private_subnets)]
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = base64encode("#!/bin/bash\necho 'App Server Running'")

  tags = {
    Name = "${var.environment}-app-${count.index + 1}"
    Tier = "app"
  }
}
