# Terraform File Organization Guide

## 📁 Project File Structure

This project demonstrates **Terraform best practices** for file organization:

```
testing-tf/
├── terraform.tf              ← Configuration & Provider (Start here!)
├── main.tf                   ← Infrastructure Resources
├── variables.tf              ← Variable Definitions
├── outputs.tf                ← Output Definitions
├── terraform.tfvars          ← Variable Values (Your Config)
├── terraform.tfvars.example  ← Example Configuration
├── .gitignore                ← Git ignore rules
├── .github/
│   └── workflows/
│       └── terraform.yml     ← GitHub Actions CI/CD
├── modules/
│   ├── ec2/                  ← EC2 Module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── alb/                  ← ALB Module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md, QUICKSTART.md, FILE_ORGANIZATION.md
```

---

## 📋 File Purposes Explained

### 1. **terraform.tf** - Terraform Block & Provider
   **What goes here:**
   - `terraform {}` block - version requirements
   - `required_providers` - plugin versions
   - `backend` configuration - remote state
   - `provider "aws" {}` - AWS configuration

   **Why separate?**
   - Clean organization
   - Easy to find provider config
   - One place to configure state backend

   **Example:**
   ```hcl
   terraform {
     required_version = ">= 1.0"
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   }

   provider "aws" {
     region = var.aws_region
   }
   ```

---

### 2. **main.tf** - Core Infrastructure Resources
   **What goes here:**
   - Data sources (query AWS resources)
   - Module blocks (call modules)
   - Resources (EC2, ALB, S3, etc.)

   **Why separate?**
   - Keeps terraform.tf clean
   - Easier to understand infrastructure
   - Main logic in one place

   **Example:**
   ```hcl
   # Data sources
   data "aws_vpc" "default" {
     default = true
   }

   # Modules
   module "ec2" {
     source = "./modules/ec2"
     vpc_id = data.aws_vpc.default.id
   }

   # Resources
   resource "aws_s3_bucket" "app_bucket" {
     bucket = "my-bucket"
   }
   ```

---

### 3. **variables.tf** - Input Variable Definitions
   **What goes here:**
   - `variable {}` blocks for all inputs
   - Variable type (string, number, list, etc.)
   - Description
   - Default values
   - Validation rules

   **Why separate?**
   - Clear list of inputs needed
   - Easy to see what can be customized
   - Documentation for users

   **Example:**
   ```hcl
   variable "aws_region" {
     description = "AWS region"
     type        = string
     default     = "us-east-1"
   }

   variable "instance_count" {
     description = "Number of instances"
     type        = number
     default     = 2
   }
   ```

---

### 4. **outputs.tf** - Output Definitions
   **What goes here:**
   - `output {}` blocks
   - Values to display after `terraform apply`
   - Values to use in other tools

   **Why separate?**
   - Clear what's exported
   - Referenceable by other configs
   - Documentation of important values

   **Example:**
   ```hcl
   output "alb_dns_name" {
     description = "ALB DNS name"
     value       = module.alb.alb_dns_name
   }

   output "instance_ids" {
     description = "EC2 instance IDs"
     value       = module.ec2.instance_ids
   }
   ```

---

### 5. **terraform.tfvars** - Variable Values (Your Config)
   **What goes here:**
   - Actual values for variables
   - Configuration for your deployment
   - Sensitive values (should be `.gitignore`d)

   **Why separate?**
   - Different per environment
   - Not in version control
   - Easy to change without editing code

   **Example:**
   ```hcl
   aws_region  = "us-east-1"
   environment = "dev"
   instance_count = 2
   ```

---

### 6. **terraform.tfvars.example** - Example Configuration Template
   **What goes here:**
   - Example values for terraform.tfvars
   - Comments explaining each variable
   - Different scenario examples

   **Why separate?**
   - Safe to commit to Git
   - Shows users what to customize
   - Template for new deployments

   **Example:**
   ```hcl
   # === Development ===
   # aws_region  = "us-east-1"
   # instance_count = 2

   # === Production ===
   # aws_region  = "us-east-1"
   # instance_count = 5
   ```

---

### 7. **Module Files** - Reusable Infrastructure

   **EC2 Module** (`modules/ec2/`)
   ```
   main.tf        ← EC2 resources & security groups
   variables.tf   ← EC2 module inputs
   outputs.tf     ← EC2 module outputs
   ```

   **ALB Module** (`modules/alb/`)
   ```
   main.tf        ← ALB & target group resources
   variables.tf   ← ALB module inputs
   outputs.tf     ← ALB module outputs
   ```

---

## 🔄 File Relationships

```
terraform.tf (config & provider)
    ↓
main.tf (infrastructure)
    ├→ variables.tf (input definitions)
    ├→ outputs.tf (output definitions)
    └→ modules/ (reusable blocks)

terraform.tfvars (your config values)
    ↓ fills →
variables.tf
```

---

## 📖 How to Read This Project

### For Beginners:

**Day 1: Understand Configuration**
1. Read `terraform.tf` - See what Terraform needs
2. Read `terraform.tfvars` - See variable values
3. Understand: Provider, Region, Project Name

**Day 2: Infrastructure Resources**
1. Read `main.tf` - See what gets created
2. Look at `data` blocks - Understand querying AWS
3. Understand: Data sources, Resources

**Day 3: Modules**
1. Read `modules/ec2/main.tf` - See EC2 module
2. Read `modules/alb/main.tf` - See ALB module
3. See in `main.tf` how modules are called
4. Understand: Module structure, reusability

**Day 4: Variables & Outputs**
1. Read `variables.tf` - Input definitions
2. Read `terraform.tfvars` - Actual values
3. Read `outputs.tf` - Output definitions
4. Understand: How data flows in/out

**Day 5: CI/CD**
1. Read `.github/workflows/terraform.yml`
2. Understand: Plan on PR, Apply on main

---

## 💡 File Organization Best Practices

✅ **DO:**
- Separate `terraform.tf` for config
- Separate `variables.tf` for definitions
- Separate `outputs.tf` for exports
- Use meaningful variable names
- Add descriptions to all variables
- Use `terraform.tfvars.example` as template

❌ **DON'T:**
- Put everything in one giant `main.tf`
- Leave variables without descriptions
- Hardcode values in resources
- Commit sensitive `terraform.tfvars` to Git
- Mix different concern types in one file

---

## 🎯 Quick Reference

| Task | File |
|------|------|
| Change AWS region | `terraform.tfvars` |
| Add new variable | `variables.tf` + `main.tf` + `terraform.tfvars` |
| Change instance count | `terraform.tfvars` |
| See outputs after apply | `outputs.tf` |
| Configure AWS provider | `terraform.tf` |
| See infrastructure code | `main.tf` |
| See module code | `modules/*/main.tf` |

---

## 🚀 Common Workflows

### Change Instance Count:
```
Edit: terraform.tfvars (change web_tier_instance_count)
Run: terraform plan
Run: terraform apply
```

### Add New Variable:
```
1. Edit: variables.tf (add variable block)
2. Edit: main.tf (use variable in resource)
3. Edit: terraform.tfvars (add value)
4. Run: terraform validate
```

### View Deployed Values:
```
Run: terraform output
Run: terraform output alb_dns_name (specific)
```

---

## 📝 Teaching Tips

- Start with `terraform.tf` to explain what Terraform needs
- Show `terraform.tfvars` to explain customization
- Move to `main.tf` to show infrastructure code
- Use modules to show code organization
- End with `outputs.tf` to show what's returned

---

## 🔐 Important Notes

### Files to Gitignore (already done):
```
terraform.tfstate       ← Current state (sensitive!)
terraform.tfstate.*     ← State backups
.terraform/             ← Downloaded plugins
*.tfvars                ← Sensitive values
!terraform.tfvars.example  ← Keep this one!
```

### Files to Commit to Git:
```
terraform.tf            ✅
main.tf                 ✅
variables.tf            ✅
outputs.tf              ✅
terraform.tfvars.example  ✅
modules/                ✅
.github/workflows/      ✅
README.md               ✅
```

---

**Understanding file organization is key to writing maintainable Terraform code!**
