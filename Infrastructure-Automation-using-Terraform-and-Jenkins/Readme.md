# Terraform Project 4.3 Notes

## Infrastructure Automation using Terraform and Jenkins

Quick revision notes for future reference.

------------------------------------------------------------------------

# Objective

Automate Terraform deployments using Jenkins.

Learn to: - Store Terraform code in GitHub - Configure Jenkins - Create
a Jenkins Pipeline - Execute Terraform automatically - Deploy
infrastructure to AWS - Monitor pipeline execution

------------------------------------------------------------------------

# Architecture

``` text
Developer
   |
GitHub
   |
Jenkins Pipeline
   |
Checkout
Init
Validate
Plan
Apply
   |
AWS
```

------------------------------------------------------------------------

# Prerequisites

-   Jenkins
-   Terraform
-   Git
-   AWS CLI
-   AWS Credentials
-   GitHub Repository

------------------------------------------------------------------------

# Workflow

``` text
Terraform Code
      ↓
Push to GitHub
      ↓
Create Jenkins Pipeline
      ↓
Checkout Code
      ↓
terraform init
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
AWS Infrastructure
```

------------------------------------------------------------------------

# Tasks

## Task 1

Prepare GitHub repository with Terraform code and Jenkinsfile.

## Task 2

Configure Jenkins.

Verify:

``` bash
terraform version
aws --version
git --version
```

## Task 3

Create Jenkins Pipeline.

Pipeline → Pipeline from SCM

Repository → Branch → Jenkinsfile

## Task 4

Pipeline stages:

-   Checkout
-   Terraform Init
-   Terraform Validate
-   Terraform Plan
-   Terraform Apply

## Task 5

Run:

Build Now

## Task 6

Verify EC2 in AWS Console.

## Task 7

Check Jenkins Console Output and Build History.

------------------------------------------------------------------------

# Important Commands

``` bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
terraform output

git add .
git commit -m "message"
git push origin main
```

------------------------------------------------------------------------

# Screenshots

1.  GitHub repository
2.  Jenkins Pipeline configuration
3.  Pipeline stages
4.  EC2 instance in AWS
5.  Jenkins console output

------------------------------------------------------------------------

# Common Errors

Terraform not found → Configure Terraform tool in Jenkins.

Git checkout failed → Verify repository URL and credentials.

AWS authentication failed → Check IAM credentials.

------------------------------------------------------------------------

# Interview Questions

What is IaC?

Infrastructure managed through code.

Why Jenkins with Terraform?

To automate infrastructure deployments.

What does terraform plan do?

Shows proposed changes.

What does terraform apply do?

Creates or updates infrastructure.

------------------------------------------------------------------------

# Revision Checklist

-   GitHub ready
-   Jenkins configured
-   Terraform installed
-   Pipeline created
-   Init works
-   Validate works
-   Plan works
-   Apply works
-   EC2 verified
-   Console output reviewed
