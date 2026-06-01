# ============================================
# Root Configuration Variables
# ============================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-app"
}

# ============================================
# EC2 Configuration Variables
# ============================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "web_tier_instance_count" {
  description = "Number of web tier instances"
  type        = number
  default     = 2
}

variable "app_tier_instance_count" {
  description = "Number of app tier instances"
  type        = number
  default     = 2
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access (Change to your IP)"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

# ============================================
# ALB Configuration Variables
# ============================================

variable "alb_allowed_cidr_blocks" {
  description = "CIDR blocks allowed for ALB access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "use_default_vpc" {
  description = "(Optional) Use the AWS default VPC instead of creating a custom VPC"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "(Optional) CIDR block for a custom VPC if one is created"
  type        = string
  default     = "10.0.0.0/16"
}

# ============================================
# Storage Configuration Variables
# ============================================

variable "s3_bucket_name" {
  description = "S3 bucket name prefix"
  type        = string
  default     = "my-app-bucket"
}
