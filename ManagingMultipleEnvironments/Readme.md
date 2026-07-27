# Terraform Project 4.2 Notes

## Managing Multiple Environments using Terraform Workspaces

These notes are intended as a quick revision guide for future reference.

------------------------------------------------------------------------

# Objective

-   Manage Development, Staging and Production using the same Terraform
    code.
-   Keep separate state files for each environment.
-   Learn to create, switch and use Terraform Workspaces.

------------------------------------------------------------------------

# What is a Terraform Workspace?

A Workspace lets you reuse the same Terraform configuration for multiple
environments while maintaining separate state files.

Example:

Development Staging Production

------------------------------------------------------------------------

# Project Structure

``` text
terraform-workspaces/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

------------------------------------------------------------------------
# Architecture
```
           Project 4.2 – Managing Multiple Environments using Terraform Workspaces

                         +---------------------------+
                         |        Developer          |
                         | terraform workspace       |
                         | select / new / apply      |
                         +------------+--------------+
                                      |
                                      ▼
                         +---------------------------+
                         | Terraform Configuration   |
                         |---------------------------|
                         | main.tf                   |
                         | variables.tf              |
                         | provider.tf               |
                         | terraform.tfvars          |
                         +------------+--------------+
                                      |
                                      ▼
                         +---------------------------+
                         | Terraform Workspaces      |
                         +------------+--------------+
                                      |
                 +--------------------+--------------------+
                 |                    |                    |
                 ▼                    ▼                    ▼
      +------------------+  +------------------+  +------------------+
      | Development      |  | Staging          |  | Production       |
      | Workspace         |  | Workspace        |  | Workspace        |
      +---------+--------+  +---------+--------+  +---------+--------+
                |                     |                     |
                +----------+----------+----------+----------+
                           |                     |
                           ▼                     ▼
                 +-----------------------------------------+
                 |          AWS Infrastructure             |
                 |-----------------------------------------|
                 | EC2 Instance                            |
                 | Security Group                          |
                 | VPC (if configured)                     |
                 +------------------+----------------------+
                                    |
                                    ▼
                        +----------------------------+
                        | Separate Terraform State   |
                        | for Each Workspace         |
                        +----------------------------+


```


# Project Flow

``` text
Prepare Project
      ↓
terraform init
      ↓
Create Workspaces
      ↓
Select Workspace
      ↓
terraform plan
      ↓
terraform apply
      ↓
Verify Isolation
```

------------------------------------------------------------------------

# Tasks Summary

## Task 1

Prepare the Terraform project (reuse Project 4.1).

Use:

``` hcl
tags = {
  Name = "${terraform.workspace}-Server"
}
```

## Task 2

Initialize:

``` bash
terraform init
```

Check workspace:

``` bash
terraform workspace show
```

## Task 3

Create workspaces:

``` bash
terraform workspace new development
terraform workspace new staging
terraform workspace new production
```

List:

``` bash
terraform workspace list
```

Switch:

``` bash
terraform workspace select development
```

## Task 4

Deploy Development:

``` bash
terraform apply
```

Creates:

development-Server

## Task 5

Switch:

``` bash
terraform workspace select staging
terraform apply
```

Creates:

staging-Server

## Task 6

Switch:

``` bash
terraform workspace select production
terraform apply
```

Creates:

production-Server

## Task 7

Preview changes:

``` bash
terraform plan
```

Apply:

``` bash
terraform apply
```

## Task 8

Verify isolation:

``` bash
terraform state list
```

Each workspace has its own state file:

``` text
terraform.tfstate.d/
├── development/
├── staging/
└── production/
```

------------------------------------------------------------------------

# Important Commands

``` bash
terraform init
terraform workspace show
terraform workspace list
terraform workspace new development
terraform workspace new staging
terraform workspace new production
terraform workspace select development
terraform workspace select staging
terraform workspace select production
terraform plan
terraform apply
terraform output
terraform state list
terraform destroy
```

------------------------------------------------------------------------

# Screenshots

Required:

1.  Workspace list
2.  Workspace switching
3.  Terraform plan
4.  EC2 resources created in different environments

Recommended:

-   terraform init
-   terraform workspace show
-   terraform state list
-   terraform.tfstate.d folder

------------------------------------------------------------------------

# Interview Questions

**What is a Terraform Workspace?**

A feature that allows multiple environments using the same configuration
with separate state files.

**Why use Workspaces?**

To avoid maintaining separate Terraform projects.

**How to list workspaces?**

``` bash
terraform workspace list
```

**How to switch workspace?**

``` bash
terraform workspace select development
```

**How to know the active workspace?**

``` bash
terraform workspace show
```

------------------------------------------------------------------------

# Revision Checklist

-   Initialize Terraform
-   Create workspaces
-   Switch workspaces
-   Deploy infrastructure
-   Verify separate state files
-   Use terraform plan before apply
