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
