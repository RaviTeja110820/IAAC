# Terraform Project 4.1 Notes

## Managing Terraform Modules, Outputs and State File

> Quick revision notes for future reference.

------------------------------------------------------------------------

# Project Objective

Learn how to: - Organize Terraform code - Create reusable modules - Use
modules from the root configuration - Define output variables -
Understand Terraform state - Modify infrastructure safely

------------------------------------------------------------------------

# Project Structure

``` text
terraform-project/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
├── terraform.tfstate      # Created after apply
├── .terraform.lock.hcl    # Created after init
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

------------------------------------------------------------------------

# File Purpose
```
  File                       Purpose
  -------------------------- --------------------------------
  provider.tf                Provider and Terraform version
  variables.tf               Input variables
  terraform.tfvars           Variable values
  main.tf                    Calls the EC2 module
  outputs.tf                 Displays useful outputs
  modules/ec2/main.tf        Creates EC2
  modules/ec2/variables.tf   Module inputs
  modules/ec2/outputs.tf     Module outputs
  terraform.tfstate          Tracks deployed infrastructure
```
------------------------------------------------------------------------

# Module Concept

Instead of placing everything in one `main.tf`, create reusable
components.

    Root Module
        │
        └── module "ec2_instance"
                │
                ▼
          modules/ec2/
                │
                ▼
          aws_instance.server

Benefits: - Reusable - Easy maintenance - Cleaner code - Scalable

------------------------------------------------------------------------

# Execution Flow

``` text
terraform init
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
terraform output
      ↓
terraform show / terraform state
```

------------------------------------------------------------------------

# Important Commands

## Initialize

``` bash
terraform init
```

Downloads providers and modules.

## Validate

``` bash
terraform validate
```

Checks syntax.

## Plan

``` bash
terraform plan
```

Shows changes before deployment.

## Apply

``` bash
terraform apply
```

Creates/updates resources.

## Destroy

``` bash
terraform destroy
```

Deletes resources.

------------------------------------------------------------------------

# Outputs

Example outputs:

``` text
instance_id
public_ip
public_dns
```

Display them with:

``` bash
terraform output
```

------------------------------------------------------------------------

# Terraform State

State file:

``` text
terraform.tfstate
```

Stores: - Resource IDs - Public IPs - Tags - Resource attributes -
Current infrastructure state

Useful commands:

``` bash
terraform show
terraform state list
terraform state show module.ec2_instance.aws_instance.server
```

------------------------------------------------------------------------

# Modifying Infrastructure

Example:

Before

``` hcl
instance_type = "t2.micro"
```

After

``` hcl
instance_type = "t2.small"
```

Run:

``` bash
terraform plan
terraform apply
```

Terraform updates only the changed resource.

------------------------------------------------------------------------

# Screenshots to Submit

1.  Project structure
2.  Module configuration
3.  `terraform apply` outputs
4.  `terraform.tfstate`
5.  Infrastructure update (`terraform plan` after modification)

Optional: - `terraform init` - `terraform validate` -
`terraform state list`

------------------------------------------------------------------------

# Common Errors

## Provider not initialized

``` bash
terraform init
```

## Invalid configuration

``` bash
terraform validate
```

## Check planned changes

``` bash
terraform plan
```

## AWS authentication issue

Verify: - AWS CLI credentials - IAM permissions - AWS Region

------------------------------------------------------------------------

# Revision Checklist

-   [ ] Understand project structure
-   [ ] Know root module vs child module
-   [ ] Create reusable module
-   [ ] Pass variables
-   [ ] Use outputs
-   [ ] Run init → validate → plan → apply
-   [ ] Understand terraform.tfstate
-   [ ] Modify infrastructure
-   [ ] Read plan before apply

------------------------------------------------------------------------

# Interview Questions

**What is a Terraform module?** A reusable collection of Terraform
configuration files.

**Why use modules?** To improve reusability, readability, and
maintainability.

**What is terraform.tfstate?** A file that stores the current state of
deployed infrastructure.

**Difference between variables.tf and terraform.tfvars?**

-   `variables.tf` → Declares variables.
-   `terraform.tfvars` → Assigns values to those variables.

**What does `terraform plan` do?** Shows proposed changes without
applying them.

**What does `terraform apply` do?** Creates or updates infrastructure.

**What does `terraform output` do?** Displays output values after
deployment.

------------------------------------------------------------------------

# Quick Commands

``` bash
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform show
terraform state list
terraform state show module.ec2_instance.aws_instance.server
terraform destroy
```
