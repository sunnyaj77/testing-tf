# ============================================
# ALB Module - Input Variables
# ============================================

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "web_tier_instance_ids" {
  description = "Web tier instance IDs (cross-module reference)"
  type        = list(string)
}

variable "app_tier_instance_ids" {
  description = "App tier instance IDs"
  type        = list(string)
}

variable "alb_name" {
  description = "ALB name"
  type        = string
  default     = "app-alb"
}

variable "alb_sg_name" {
  description = "ALB security group name"
  type        = string
  default     = "alb-sg"
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for ALB access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "web_target_group_name" {
  description = "Web target group name"
  type        = string
  default     = "web-tg"
}
