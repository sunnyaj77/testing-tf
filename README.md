# 2-Tier AWS Terraform Infrastructure - Learning Project

This is a **beginner-friendly** Terraform project designed for **teaching Terraform concepts** including modules, variables, references, and CI/CD integration.

## 🎯 Learning Objectives

By working with this project, you'll learn:

✅ **Terraform Basics**
  - Variable definitions and usage
  - Resource creation
  - Data sources
  - Outputs

✅ **Module Usage**
  - Creating modules
  - Passing variables to modules
  - Using module outputs
  - Cross-module references

✅ **Infrastructure as Code**
  - 2-tier architecture (Web tier + App tier)
  - Security groups and network isolation
  - Load balancing with ALB
  - Storage with S3

✅ **CI/CD Integration**
  - GitHub Actions workflow
  - Automated plan on PR
  - Automated apply on merge
  - AWS integration

## 🏗️ Architecture

```
┌─────────────────────────────────┐
│       Public Internet           │
└────────────┬────────────────────┘
             │
      ┌──────▼──────┐
      │     ALB     │
      │   (Load     │
      │ Balancer)   │
      └──────┬──────┘
             │
    ┌────────┴────────┐
    │                 │
┌───▼──────┐  ┌──────▼──┐
│ Web Tier │  │ App Tier │
│ (EC2)    │  │ (EC2)    │
└──────────┘  └──────────┘
    (Public)    (Private)
```

## 📁 Project Structure

```
.
├── main.tf                 # Main infrastructure code
├── variables.tf            # Variable definitions  
├── outputs.tf              # Output definitions
├── terraform.tfvars        # Variable values
├── .gitignore              # Git ignore rules
├── modules/
│   ├── ec2/                # EC2 module
│   │   ├── main.tf        # EC2 resources
│   │   ├── variables.tf    # EC2 variables
│   │   └── outputs.tf      # EC2 outputs
│   └── alb/                # ALB module
│       ├── main.tf        # ALB resources
│       ├── variables.tf    # ALB variables
│       └── outputs.tf      # ALB outputs
├── .github/
│   └── workflows/
│       └── terraform.yml   # GitHub Actions workflow
└── README.md
```

## 🚀 Quick Start

### 1. Prerequisites

```bash
# Install Terraform
terraform version  # Should be >= 1.0

# Configure AWS credentials
aws configure
# Enter your AWS Access Key and Secret Key
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd testing-tf
```

### 3. Initialize Terraform

```bash
terraform init
```

This downloads:
- AWS provider plugin
- Required modules

### 4. Review the Plan

```bash
terraform plan
```

This shows:
- What resources will be created
- No actual changes yet

### 5. Apply Changes

```bash
terraform apply
```

Press `yes` to confirm.

### 6. Access Your Application

```bash
# Get the load balancer DNS
terraform output alb_dns_name

# Visit in browser
http://<ALB_DNS_NAME>
```

### 7. Destroy (when done learning)

```bash
terraform destroy
```

Press `yes` to confirm.

## 📚 Key Concepts Demonstrated

### 1. Variables (variables.tf)

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

**What you learn:**
- How to define input variables
- Variable types (string, number, list, etc.)
- Default values

### 2. Modules (main.tf)

```hcl
module \"ec2\" {
  source = \"./modules/ec2\"
  
  vpc_id           = data.aws_vpc.default.id
  instance_type    = var.instance_type
  
  # Cross-module reference
  alb_security_group_id = module.alb.alb_security_group_id
}
```

**What you learn:**
- Module source location
- Passing variables to modules
- Using module outputs

### 3. Data Sources (main.tf)

```hcl
data \"aws_vpc\" \"default\" {
  default = true
}

data \"aws_availability_zones\" \"available\" {
  state = \"available\"
}
```

**What you learn:**
- Reference existing AWS resources
- Query AWS data
- Use in resource creation

### 4. Cross-Module References (main.tf)

```hcl
# EC2 module uses ALB security group
module \"ec2\" {
  alb_security_group_id = module.alb.alb_security_group_id
}

# ALB module uses EC2 instance IDs
module \"alb\" {
  web_tier_instance_ids = module.ec2.web_tier_instance_ids
}
```

**What you learn:**
- How modules communicate
- Dependency management
- Output → Input flow

### 5. Outputs (main.tf)

```hcl
output \"alb_dns_name\" {
  description = \"ALB DNS name\"
  value       = module.alb.alb_dns_name
}
```

**What you learn:**
- Expose important values
- Display information to users
- Use in other tools/scripts

## 🔄 CI/CD Workflow (.github/workflows/terraform.yml)

### On Pull Request:
1. ✅ Format check (`terraform fmt`)
2. ✅ Initialize (`terraform init`)
3. ✅ Validate (`terraform validate`)
4. ✅ Plan (`terraform plan`)
5. ✅ Comment plan on PR

### On Push to Main:
1. ✅ All PR checks
2. ✅ Automatic apply (`terraform apply`)
3. ✅ Infrastructure updated automatically

## 🔧 Customization Examples

### Change Number of Instances

Edit `terraform.tfvars`:
```hcl
web_tier_instance_count = 3
app_tier_instance_count = 3
```

Then:
```bash
terraform plan
terraform apply
```

### Change Instance Type

Edit `terraform.tfvars`:
```hcl
instance_type = \"t3.small\"
```

### Allow SSH from Your IP

Edit `terraform.tfvars`:
```hcl
allowed_ssh_cidr = [\"YOUR_IP/32\"]
```

Get your IP:
```bash
curl -s https://checkip.amazonaws.com
```

## 📖 Learning Path

1. **Day 1: Variables & Basic Resources**
   - Read: `variables.tf`
   - Read: `main.tf` (data sources and S3 bucket)
   - Run: `terraform init` and `terraform plan`

2. **Day 2: Modules**
   - Read: `modules/ec2/main.tf`
   - Read: `modules/alb/main.tf`
   - Read: How modules are used in `main.tf`

3. **Day 3: References & Dependencies**
   - Study cross-module references in `main.tf`
   - Look at `depends_on` clauses
   - Understand module outputs

4. **Day 4: CI/CD**
   - Read: `.github/workflows/terraform.yml`
   - Create a PR and see workflow run
   - Push to main and see apply

5. **Day 5: Practice**
   - Modify variables
   - Add new resources
   - Experiment with modules

## 🧪 Common Commands

```bash
# Initialize working directory
terraform init

# Format code
terraform fmt -recursive

# Validate syntax
terraform validate

# See what will change
terraform plan

# Apply changes
terraform apply

# See current state
terraform show

# Destroy resources
terraform destroy

# Get specific output
terraform output alb_dns_name

# Refresh state
terraform refresh
```

## ⚠️ Important Notes

### AWS Free Tier

- `t3.micro` instances are free-tier eligible
- NAT Gateway is NOT free tier (~$32/month)
- ALB is NOT free tier (~$16/month)
- **Estimated cost: ~$50/month if outside free tier**

### Security

- Default `allowed_ssh_cidr = [\"0.0.0.0/32\"]` blocks all SSH
- Change to your IP for actual SSH access
- ALB allows traffic from anywhere by default
- For production: restrict CIDR blocks appropriately

### State Management

Terraform stores state in `terraform.tfstate` file:
- ⚠️ Contains sensitive information
- ⚠️ Do NOT commit to Git
- ✅ Already in `.gitignore`

For team collaboration, use remote backend:
```hcl
backend \"s3\" {
  bucket = \"your-bucket\"
  key    = \"terraform.tfstate\"
  region = \"us-east-1\"
}
```

## 🆘 Troubleshooting

### Error: \"No valid AWS credentials\"

```bash
aws configure
```

### Error: \"Subnet not available\"

Some regions have fewer availability zones. Change `aws_region` in `terraform.tfvars`

### Instances not reaching healthy

SSH into instance and check services running

### GitHub Actions fails

Check secrets in repository settings (AWS credentials)

## 🔗 Additional Resources

- [Terraform Docs](https://www.terraform.io/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Modules Guide](https://www.terraform.io/docs/modules/index.html)
- [GitHub Actions Guide](https://docs.github.com/en/actions)

## 📝 Practice Exercises

1. **Add EC2 Tags:** Add `Owner` tag to all instances
2. **Create NAT Gateway:** Add NAT gateway to allow private subnet outbound access
3. **Add CloudWatch Alarm:** Create alarm for CPU utilization
4. **Enable Logging:** Add S3 bucket logging
5. **Advanced Routing:** Add path-based routing in ALB

## 👨‍🏫 Teaching Tips

- Start with `main.tf` to show overall structure
- Explain each block: `terraform`, `provider`, `data`, `resource`
- Show how modules are called
- Demonstrate `terraform plan` output
- Point out cross-module references
- Run `terraform destroy` to show cleanup

---

**Ready to learn? Start with `terraform init` and `terraform plan`!**

