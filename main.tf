# ============================================
# 2-Tier AWS Infrastructure - Main Resources
# Teaching: Modules, Variables, and References
# ============================================

# ============================================
# Data Sources - Get existing AWS resources
# ============================================

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# ============================================
# ALB Security Group - Shared resource between ALB and EC2
# ============================================
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${var.environment}"
  description = "Security group for the application load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# ============================================
# EC2 Module - Deploy Web and App Tier Instances
# ============================================
# This demonstrates:
# - Using module block
# - Passing variables to module
# - Referencing module outputs
# ============================================

module "ec2" {
  source = "./modules/ec2"

  # Pass data to module
  vpc_id                = data.aws_vpc.default.id
  public_subnets       = slice(data.aws_subnets.default.ids, 0, 2)
  private_subnets      = slice(data.aws_subnets.default.ids, 2, 4)
  environment          = var.environment
  instance_type        = var.instance_type
  web_tier_instance_count = var.web_tier_instance_count
  app_tier_instance_count = var.app_tier_instance_count

  # ALB security group is created at the root level to avoid circular module dependencies
  alb_security_group_id = aws_security_group.alb_sg.id
  allowed_ssh_cidr      = var.allowed_ssh_cidr
}

# ============================================
# ALB Module - Deploy Application Load Balancer
# ============================================
# This demonstrates:
# - Module dependency (depends_on)
# - Cross-module references (EC2 instance IDs)
# - Output values from one module used in another
# ============================================

module "alb" {
  source = "./modules/alb"

  # Pass data to module
  vpc_id              = data.aws_vpc.default.id
  public_subnets          = slice(data.aws_subnets.default.ids, 0, 2)
  environment             = var.environment
  allowed_cidr_blocks     = var.alb_allowed_cidr_blocks
  alb_security_group_id   = aws_security_group.alb_sg.id

  # Cross-module reference: Use EC2 instance IDs from EC2 module
  web_tier_instance_ids = module.ec2.web_tier_instance_ids
  app_tier_instance_ids = module.ec2.app_tier_instance_ids

  depends_on = [module.ec2]
}

# ============================================
# S3 Bucket - Application Storage
# ============================================
# This demonstrates:
# - Data source reference (account ID)
# - Resource creation
# - Separate configuration blocks for sub-resources
# ============================================

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.s3_bucket_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}

# Enable versioning on S3 bucket
resource "aws_s3_bucket_versioning" "app_bucket" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
