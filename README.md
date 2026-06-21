# Terraform Complete Notes

## What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool developed by **HashiCorp**.

Terraform allows you to create, modify, and destroy infrastructure using code instead of manually creating resources through cloud consoles.

Terraform supports multiple cloud providers:

* AWS
* Azure
* GCP
* Oracle Cloud
* Kubernetes
* VMware

### Key Features

* Open Source
* Platform Independent
* Written in Go (Golang)
* Uses HCL (HashiCorp Configuration Language)
* Infrastructure as Code (IaC)

---

# Terraform Architecture

```text
+--------------------------------------------------+
|                 TERRAFORM CLIENT                 |
|--------------------------------------------------|
|                                                  |
|  Terraform Code (.tf files)                      |
|                                                  |
|  Provider Block                                  |
|  Resource Block                                  |
|  Variables                                       |
|  Outputs                                         |
|                                                  |
|  terraform.tfstate                               |
|  (Current infrastructure state)                  |
|                                                  |
+-------------------+------------------------------+
                    |
                    |
                    | Authentication
                    | (Access Key / Secret Key)
                    |
                    v

+--------------------------------------------------+
|                 PROVIDER PLUGIN                  |
|--------------------------------------------------|
| AWS Provider                                     |
| Azure Provider                                   |
| GCP Provider                                     |
| Kubernetes Provider                              |
+-------------------+------------------------------+
                    |
                    |
                    v

+--------------------------------------------------+
|               CLOUD INFRASTRUCTURE               |
|--------------------------------------------------|
| EC2 Instances                                    |
| VPC                                               |
| Security Groups                                  |
| Load Balancers                                   |
| Databases                                        |
| Storage                                          |
+--------------------------------------------------+
```

---

## Components of Terraform Architecture

### Terraform Core

Terraform Core is the main engine of Terraform.

Responsibilities:

* Reads `.tf` files
* Builds execution plans
* Downloads provider plugins
* Maintains state file
* Applies infrastructure changes

---

### Terraform Configuration Files

Terraform code is stored inside files ending with:

```text
.tf
```

Examples:

```text
main.tf
variables.tf
outputs.tf
provider.tf
```

Terraform code is written using:

```text
HCL (HashiCorp Configuration Language)
```

Example:

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

---

### Provider Plugin

Provider acts as a bridge between Terraform and cloud platforms.

Examples:

* AWS Provider
* Azure Provider
* Google Provider
* Kubernetes Provider

Example:

```hcl
# AWS Provider Configuration

provider "aws" {

  # AWS Region
  region = "us-east-1"

}
```

---

### Terraform State File

Terraform stores infrastructure information inside:

```text
terraform.tfstate
```

Purpose:

* Tracks resources created by Terraform
* Maps code with real infrastructure
* Detects changes
* Helps in updates and deletion

---

# Terraform Workflow

```text
Write Terraform Code
         |
         v
terraform init
         |
         v
terraform validate
         |
         v
terraform plan
         |
         v
terraform apply
         |
         v
Infrastructure Created
         |
         v
terraform.tfstate Updated
```

---

# Terraform Installation (Ubuntu)

## Install Required Packages

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

## Add HashiCorp GPG Key

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

## Add Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

## Install Terraform

```bash
sudo apt update

sudo apt-get install terraform
```

## Verify Installation

```bash
terraform --version
```

---

# Demo 1: Configure AWS Credentials

## Install AWS CLI

```bash
sudo apt-get update

sudo apt-get install awscli -y
```

## Configure Credentials

```bash
aws configure
```

Provide:

```text
AWS Access Key
AWS Secret Key
```

Verify:

```bash
cat ~/.aws/credentials
```

Example:

```ini
[default]
aws_access_key_id=XXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXX
```

---

# Demo 2: Provider Block

Create Working Directory

```bash
mkdir myterraformfiles

cd myterraformfiles
```

Create Terraform File

```bash
vim aws_infra.tf
```

```hcl
# Configure AWS Provider

provider "aws" {

  # AWS Region
  region = "us-east-1"

}
```

Initialize Terraform

```bash
terraform init
```

---

## What Does terraform init Do?

* Downloads Provider Plugins
* Creates `.terraform` Directory
* Initializes Project

---

# Demo 3: Create EC2 Instance

```hcl
# Create EC2 Instance

resource "aws_instance" "myec2" {

  # Amazon Machine Image
  ami = "ami-063d43db0594b521b"

  # Instance Type
  instance_type = "t2.micro"

  tags = {

    # EC2 Name
    Name = "Instance1"

  }

}
```

Validate Configuration

```bash
terraform validate
```

Generate Plan

```bash
terraform plan
```

Create Resources

```bash
terraform apply
```

---

# Demo 4: Destroy Resources

```bash
terraform destroy
```

---

# Demo 5: Count Meta Argument

Create Multiple Instances

```hcl
# Create 5 EC2 Instances

resource "aws_instance" "myec2" {

  ami = "ami-0de716d6197524dd9"

  instance_type = "t2.micro"

  count = 5

  tags = {

    Name = "instance-1"

  }

}
```

Apply

```bash
terraform apply
```

Result:

```text
5 EC2 Instances Created
```

Destroy Single Resource

```bash
terraform destroy -target aws_instance.myec2[0]
```

---

# Demo 6: Data Block

## What is a Data Block?

Data Blocks:

* Do NOT create resources
* Only fetch information
* Useful for AMIs, VPCs, Subnets

Example:

```hcl
# Fetch Latest Amazon Linux 2 AMI

data "aws_ami" "myami" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["amzn2-ami-hvm*"]

  }

  filter {

    name = "architecture"

    values = ["x86_64"]

  }

  filter {

    name = "virtualization-type"

    values = ["hvm"]

  }

}
```

Use Retrieved AMI

```hcl
resource "aws_instance" "myec2" {

  # Use AMI from Data Block
  ami = data.aws_ami.myami.id

  instance_type = "t2.micro"

}
```

---

# Demo 7: Output Block

Display Public IP

```hcl
# Show EC2 Public IP

output "ec2-public-ip" {

  value = aws_instance.myec2.public_ip

}
```

Display Instance Status

```hcl
# Show EC2 Status

output "ec2-status" {

  value = aws_instance.myec2.instance_state

}
```

Display Multiple Values

```hcl
# Display EC2 Details

output "instance_data" {

  value = {

    id         = aws_instance.myec2.id

    status     = aws_instance.myec2.instance_state

    private_ip = aws_instance.myec2.private_ip

    public_dns = aws_instance.myec2.public_dns

  }

}
```

---

# Variables in Terraform

## What are Variables?

Variables allow dynamic configuration.

Benefits:

* Reusable code
* Environment-specific values
* Avoid hardcoding

---

## String Variables

### variables.tf

```hcl
# AWS Region

variable "region" {

  default = "us-east-1"

}

# EC2 Instance Type

variable "instance_type" {

  default = "t2.micro"

}

# Environment

variable "env" {

  default = "dev"

}
```

Use Variables

```hcl
provider "aws" {

  region = var.region

  shared_credentials_files = ["~/.aws/credentials"]

}
```

```hcl
resource "aws_instance" "myec2" {

  ami = data.aws_ami.myami.id

  instance_type = var.instance_type

  tags = {

    Name = var.env

  }

}
```

---

## List Variable

```hcl
# List Variable

variable "ports" {

  type = list(number)

  default = [8080, 9090, 80]

}
```

---

## Map Variable

```hcl
# Map Variable

variable "instance" {

  type = map(string)

  default = {

    dev  = "t2.micro"

    prod = "t2.large"

  }

}
```

Usage:

```hcl
instance_type = var.instance["dev"]
```

---

## Object Variable

```hcl
variable "ec2_object" {

  type = object({

    name      = string

    ami       = string

    keys      = list(string)

    instances = number

  })

  default = {

    name      = "instance-1"

    ami       = "ami-0427090fd1714168b"

    instances = 2

    keys      = ["key1.pem", "key2.pem"]

  }

}
```

Usage:

```hcl
resource "aws_instance" "myec2" {

  ami = var.ec2_object.ami

  instance_type = var.instance["dev"]

  count = var.ec2_object.instances

  tags = {

    Name = var.ec2_object.name

  }

}
```

---

# Common Terraform Commands

```bash
# Initialize Project
terraform init

# Validate Syntax
terraform validate

# Generate Execution Plan
terraform plan

# Create Infrastructure
terraform apply

# Auto Approve Apply
terraform apply --auto-approve

# Destroy Infrastructure
terraform destroy

# Auto Approve Destroy
terraform destroy --auto-approve

# Show State
terraform show

# List State Resources
terraform state list

# Format Terraform Code
terraform fmt
```

---

# Interview Questions

### What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to provision and manage cloud infrastructure using code.

### What is terraform.tfstate?

A file that stores the current state of infrastructure managed by Terraform.

### What is a Provider?

A plugin that allows Terraform to communicate with cloud providers such as AWS, Azure, and GCP.

### What is terraform init?

Initializes the project and downloads provider plugins.

### What is terraform plan?

Shows the changes Terraform will make before applying them.

### What is terraform apply?

Creates or updates infrastructure.

### What is terraform destroy?

Deletes infrastructure managed by Terraform.

### What is a Data Block?

Used to fetch existing resource information without creating resources.

### What is Count?

Used to create multiple copies of a resource.

### What are Variables?

Variables store reusable and dynamic values used in Terraform configurations.

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

# Terraform tfvars File

## What is a tfvars File?

A **tfvars** file (Terraform Variables file) is used to **store values for variables separately from the Terraform code**.

Instead of hardcoding values inside your Terraform configuration (`.tf` files), you can define only the variable names in `variables.tf` and provide their actual values in a separate **terraform.tfvars** file.

This makes your Terraform code:

- More reusable
- Easier to maintain
- More secure (especially when storing environment-specific values)
- Easy to use across multiple environments (Dev, Test, Prod)

---

# Why Do We Need a tfvars File?

Suppose you are creating an EC2 instance.

Instead of writing:

```hcl
instance_type = "t2.micro"
region        = "us-east-1"
```

inside your Terraform code, you can write:

```hcl
instance_type = var.instance_type
region        = var.region
```

Now the actual values can come from a **terraform.tfvars** file.

This means the same Terraform code can be reused for different environments simply by changing the values in the tfvars file.

---

# Variable Block

Variables are declared inside a **variables.tf** file.

A variable block can have:

- A default value
- No default value

---

## Example 1: Variable with Default Value

### variables.tf

```hcl
# AWS Region

variable "region" {

  default = "us-east-1"

}

# EC2 Instance Type

variable "instance_type" {

  default = "t2.micro"

}
```

### What happens?

If no value is provided anywhere else, Terraform automatically uses the default values.

Result:

```
Region          : us-east-1
Instance Type   : t2.micro
```

---

## Example 2: Variable Without Default Value

### variables.tf

```hcl
# AWS Region

variable "region" {

}

# EC2 Instance Type

variable "instance_type" {

}

# Environment

variable "environment" {

}
```

Here we only declared the variables.

No values are assigned.

Terraform now expects these values from:

- Runtime
- tfvars file

If no values are supplied, Terraform throws an error.

Example:

```
Error: No value for required variable

The root module input variable "region" is not set.
```

---

# terraform.tfvars File

Create a new file.

```
terraform.tfvars
```

Example:

```hcl
# AWS Region

region = "us-east-1"

# EC2 Instance Type

instance_type = "t2.micro"

# Environment

environment = "development"
```

Notice:

There is **NO variable block** here.

Only variable names and values.

---

# How Terraform Uses tfvars

Suppose we have:

## variables.tf

```hcl
variable "region" {}

variable "instance_type" {}

variable "environment" {}
```

---

## terraform.tfvars

```hcl
region = "us-east-1"

instance_type = "t2.micro"

environment = "dev"
```

---

## main.tf

```hcl
# Configure AWS Provider

provider "aws" {

  # Region comes from tfvars file
  region = var.region

}

# Create EC2 Instance

resource "aws_instance" "myec2" {

  # Amazon Machine Image
  ami = "ami-0427090fd1714168b"

  # Instance Type from tfvars
  instance_type = var.instance_type

  tags = {

    # Environment Name from tfvars
    Name = var.environment

  }

}
```

Run:

```bash
terraform plan
```

Terraform automatically loads:

```
terraform.tfvars
```

No extra command is required.

---

# Example Using Dev Environment

## terraform.tfvars

```hcl
region = "us-east-1"

instance_type = "t2.micro"

environment = "dev"
```

Output:

```
Region          : us-east-1
Instance Type   : t2.micro
EC2 Name        : dev
```

---

# Example Using Production Environment

Change only the tfvars file.

```hcl
region = "us-west-2"

instance_type = "t2.large"

environment = "production"
```

Run again:

```bash
terraform apply
```

Now Terraform creates:

```
Region          : us-west-2
Instance Type   : t2.large
EC2 Name        : production
```

Notice:

The Terraform code never changed.

Only the tfvars file changed.

---

# Using Multiple tfvars Files

In real projects, we usually maintain separate tfvars files.

```
terraform-project/

│

├── main.tf

├── variables.tf

├── dev.tfvars

├── test.tfvars

├── prod.tfvars

└── outputs.tf
```

---

## dev.tfvars

```hcl
region = "us-east-1"

instance_type = "t2.micro"

environment = "dev"
```

---

## test.tfvars

```hcl
region = "us-east-2"

instance_type = "t2.small"

environment = "test"
```

---

## prod.tfvars

```hcl
region = "us-west-2"

instance_type = "t2.large"

environment = "prod"
```

Run:

Development

```bash
terraform apply -var-file="dev.tfvars"
```

Testing

```bash
terraform apply -var-file="test.tfvars"
```

Production

```bash
terraform apply -var-file="prod.tfvars"
```

---

# Variable Value Precedence

Terraform checks for variable values in the following order (highest to lowest priority):

| Priority | Source | Example |
|-----------|--------|---------|
| **1 (Highest)** | Runtime (`-var`) | `terraform apply -var="region=us-east-2"` |
| **2** | tfvars file | `terraform.tfvars`, `dev.tfvars` |
| **3 (Lowest)** | Variable block default | `default = "us-east-1"` |

---

# Example of Variable Precedence

## variables.tf

```hcl
variable "region" {

  default = "us-east-1"

}
```

---

## terraform.tfvars

```hcl
region = "us-west-2"
```

Run:

```bash
terraform apply
```

Result:

```
Region = us-west-2
```

Why?

Because **tfvars** has higher precedence than the default value.

---

Now run:

```bash
terraform apply -var="region=eu-west-1"
```

Result:

```
Region = eu-west-1
```

Why?

Because **runtime value** has the highest precedence.

---

# Complete Flow

```text
variables.tf
      │
      │
      ▼
Variable Declaration
      │
      ▼
terraform.tfvars
      │
      │
      ▼
Actual Values
      │
      ▼
main.tf
      │
      ▼
Terraform uses var.<variable_name>
      │
      ▼
AWS Infrastructure Created
```

---

# Best Practices

- Declare variables in `variables.tf`.
- Store values in `terraform.tfvars`.
- Use different `.tfvars` files for Dev, Test, and Production.
- Do not hardcode values in `main.tf`.
- Do not commit sensitive `.tfvars` files (passwords, access keys, secrets) to Git.
- Store secrets using environment variables, secret managers, or CI/CD secret stores instead.

---

# Interview Questions

## What is a tfvars file?

A tfvars file is used to store values for Terraform variables separately from the Terraform code.

---

## Why use tfvars?

- Avoid hardcoding values
- Support multiple environments
- Improve reusability
- Simplify maintenance

---

## What is the default tfvars filename?

```
terraform.tfvars
```

Terraform loads this file automatically if it exists.

---

## Can we have multiple tfvars files?

Yes.

Examples:

- dev.tfvars
- test.tfvars
- prod.tfvars

Use them with:

```bash
terraform apply -var-file="prod.tfvars"
```

---

## What is the precedence order of variables?

1. Runtime (`-var`)
2. tfvars file (`terraform.tfvars` or `-var-file`)
3. Default value in the variable block

---

# Summary

- Variables are declared in `variables.tf`.
- Actual values are stored in `terraform.tfvars`.
- The same Terraform code can be reused across different environments by changing only the tfvars file.
- Runtime values override tfvars values, and tfvars values override default values.
- This approach makes Terraform configurations cleaner, more maintainable, and easier to manage.