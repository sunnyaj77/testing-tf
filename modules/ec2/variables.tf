# ============================================
# EC2 Module - Input Variables
# ============================================

variable "vpc_id" {
  description = "VPC ID where instances will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs for web tier"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet IDs for app tier"
  type        = list(string)
}

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

variable "sg_name" {
  description = "Security group name"
  type        = string
  default     = "ec2-sg"
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID (cross-module reference)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}
