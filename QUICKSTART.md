# Quick Start - 5 Minutes to Terraform

## Step 1: Setup AWS (1 minute)

```bash
aws configure
# Enter AWS Access Key and Secret Key
```

## Step 2: Initialize (1 minute)

```bash
cd testing-tf
terraform init
```

## Step 3: Review Plan (1 minute)

```bash
terraform plan
```

This shows what will be created. No changes yet!

## Step 4: Apply (1 minute)

```bash
terraform apply
```

Type `yes` to confirm.

## Step 5: Access Application (1 minute)

```bash
# Get ALB DNS name
terraform output alb_dns_name

# Visit in browser
http://<ALB_DNS_NAME>
```

---

## Common Commands

```bash
terraform plan          # See what will change
terraform apply         # Make changes
terraform destroy       # Delete everything
terraform output        # Show values
terraform validate      # Check syntax
terraform fmt           # Format code
```

---

## Learning Path

1. **Read files in this order:**
   - `README.md` (understand concepts)
   - `main.tf` (see structure)
   - `modules/ec2/main.tf` (understand modules)
   - `modules/alb/main.tf` (more modules)

2. **Run commands:**
   - `terraform init`
   - `terraform validate`
   - `terraform plan`
   - `terraform apply`

3. **Experiment:**
   - Change `web_tier_instance_count` in `terraform.tfvars`
   - Run `terraform plan` to see changes
   - Run `terraform apply` to apply changes

4. **Cleanup:**
   - `terraform destroy` when done

---

## Key Files

| File | Purpose |
|------|---------|
| `main.tf` | Infrastructure code |
| `variables.tf` | Input variables |
| `terraform.tfvars` | Variable values |
| `modules/ec2/` | EC2 module |
| `modules/alb/` | ALB module |
| `.github/workflows/terraform.yml` | CI/CD pipeline |

---

## Key Concepts Shown

✅ **Variables** - Input variables and defaults  
✅ **Data Sources** - Query existing AWS resources  
✅ **Modules** - Reusable infrastructure blocks  
✅ **Cross-Module References** - modules using each other's outputs  
✅ **Outputs** - Display important values  
✅ **Resources** - Create new AWS infrastructure  

---

## Cost Estimate

Running for one month on free tier:
- **EC2 (t3.micro)**: $0 (free tier)
- **ALB**: ~$16
- **S3**: ~$0.02
- **Total**: ~$16/month

---

## Important Notes

⚠️ Change `allowed_ssh_cidr` to your IP for SSH access  
⚠️ S3 bucket name must be globally unique  
⚠️ Terraform state in `terraform.tfstate` is already gitignored  
⚠️ This uses **default VPC** - no VPC creation needed  

---

**Ready? Start with:** `terraform init`
