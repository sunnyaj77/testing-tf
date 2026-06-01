# ============================================
# Application Load Balancer Module
# ============================================

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_sg_name}-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.alb_sg_name}-${var.environment}"
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.alb_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  tags = {
    Name = "${var.alb_name}-${var.environment}"
  }
}

# Target Group for Web Tier
resource "aws_lb_target_group" "web_tg" {
  name        = "${var.web_target_group_name}-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "${var.web_target_group_name}-${var.environment}"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Register Web Tier Instances with Target Group
resource "aws_lb_target_group_attachment" "web_targets" {
  count            = length(var.web_tier_instance_ids)
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.web_tier_instance_ids[count.index]
  port             = 80
}

# Register App Tier Instances with Target Group
resource "aws_lb_target_group_attachment" "app_targets" {
  count            = length(var.app_tier_instance_ids)
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.app_tier_instance_ids[count.index]
  port             = 80
}
