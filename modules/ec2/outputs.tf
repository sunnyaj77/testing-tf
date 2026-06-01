# ============================================
# EC2 Module - Outputs
# ============================================

output "security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}

output "web_tier_instance_ids" {
  description = "Web tier instance IDs"
  value       = aws_instance.web_tier[*].id
}

output "app_tier_instance_ids" {
  description = "App tier instance IDs"
  value       = aws_instance.app_tier[*].id
}
