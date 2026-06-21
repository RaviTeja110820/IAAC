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



------------------------------------------------------------------------------------------------

# Terraform Dynamic Blocks

## What are Dynamic Blocks?

A **Dynamic Block** in Terraform is used to **generate one or more nested blocks automatically** using a loop.

Normally, if you want to create multiple nested blocks (like `ingress` rules in a security group), you have to write each block manually.

Dynamic blocks eliminate this repetition by creating the nested blocks automatically based on a list or map.

Think of it as a **for loop for nested configuration blocks**.

---

# Why Do We Need Dynamic Blocks?

Suppose you want to open multiple ports in an AWS Security Group.

Without a dynamic block, you would have to write:

```hcl
ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

Imagine you have **100 ports**.

Writing 100 ingress blocks is time-consuming and difficult to maintain.

Instead, Terraform allows us to use **Dynamic Blocks**.

---

# Real-Time Example

Suppose your DevOps team says:

> Open ports:
>
> - 22
> - 80
> - 443
> - 8080
> - 9000

Instead of writing five ingress blocks manually, you simply store the ports inside a variable.

Terraform loops through each port and creates the ingress rules automatically.

---

# How Dynamic Blocks Work

```text
Variable
(List/Map)
      │
      ▼
Dynamic Block
      │
      ▼
Terraform Loop
      │
      ▼
Generates Multiple Nested Blocks
      │
      ▼
AWS Security Group
```

---

# Syntax of Dynamic Block

```hcl
dynamic "<Nested Block Name>" {

  for_each = <Collection>

  content {

      # Block configuration

  }

}
```

---

## Components

### dynamic

Starts a dynamic block.

Example:

```hcl
dynamic "ingress"
```

Here,

`ingress` is the nested block Terraform will generate.

---

### for_each

Specifies the collection to loop through.

Example:

```hcl
for_each = var.sg_ports
```

Terraform loops through every value inside:

```text
80
443
22
```

---

### content

Everything inside `content {}` becomes one generated nested block.

---

### .value

Represents the current item in the loop.

Example

Current values:

```
80

443

22
```

First iteration:

```
ingress.value = 80
```

Second iteration:

```
ingress.value = 443
```

Third iteration:

```
ingress.value = 22
```

---

# Demo 1: Dynamic Block Using List

## Step 1 : Configure AWS Provider

```hcl
# Configure AWS Provider

provider "aws" {

  # AWS Region
  region = "us-east-1"

  # Credentials file
  shared_credentials_files = ["~/.aws/credentials"]

}
```

---

## Step 2 : Create Variable

```hcl
# List of ports to open

variable "sg_ports" {

  type = list(number)

  default = [

    80,
    443,
    22

  ]

}
```

This variable contains three ports.

```
80

443

22
```

---

## Step 3 : Create Security Group

```hcl
# Create Security Group

resource "aws_security_group" "mysg" {

  # Security Group Name
  name = "custom-sg"

  # Description
  description = "Allow inbound traffic"

  # Create multiple ingress blocks automatically
  dynamic "ingress" {

    # Loop through every port
    for_each = var.sg_ports

    content {

      # Opening same port
      from_port = ingress.value

      # Ending port
      to_port = ingress.value

      # TCP Protocol
      protocol = "tcp"

      # Allow from anywhere
      cidr_blocks = ["0.0.0.0/0"]

    }

  }

}
```

---

# What Happens Internally?

Terraform reads

```text
80

443

22
```

and automatically creates

```hcl
ingress {

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

ingress {

  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

ingress {

  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}
```

Notice:

We never wrote these three blocks manually.

Terraform generated them.

---

# Iteration Visualization

```
Loop 1

ingress.value = 80

↓

Creates Port 80


------------------------

Loop 2

ingress.value = 443

↓

Creates Port 443


------------------------

Loop 3

ingress.value = 22

↓

Creates Port 22
```

---

# Demo 2 : Dynamic Block Using Objects

Sometimes each rule contains multiple properties.

Example:

```
Port

Protocol

CIDR Block
```

A simple list cannot store all this information.

Instead we use a **list of objects**.

---

## Variable

```hcl
# List of Security Group Rules

variable "sg_config" {

  default = [

    {

      port = 80

      protocol = "tcp"

      cidr_blocks = "0.0.0.0/0"

    },

    {

      port = 8080

      protocol = "udp"

      cidr_blocks = "10.0.0.0/16"

    },

    {

      port = 22

      protocol = "tcp"

      cidr_blocks = "10.0.0.0/20"

    },

    {

      port = 443

      protocol = "tcp"

      cidr_blocks = "10.0.0.0/16"

    }

  ]

}
```

---

Each object stores

```
Port

Protocol

CIDR
```

---

## Security Group

```hcl
# Create Security Group

resource "aws_security_group" "mysg" {

  name = "custom-sg"

  description = "Allow inbound traffic"

  # Generate ingress blocks dynamically
  dynamic "ingress" {

    # Loop through every object
    for_each = var.sg_config

    content {

      # Current object's port
      from_port = ingress.value.port

      # Current object's port
      to_port = ingress.value.port

      # Current object's protocol
      protocol = ingress.value.protocol

      # Current object's CIDR
      cidr_blocks = [

        ingress.value.cidr_blocks

      ]

    }

  }

}
```

---

# How Terraform Reads This

Iteration 1

```
Port = 80

Protocol = tcp

CIDR = 0.0.0.0/0
```

Creates

```hcl
ingress {

  from_port = 80

  to_port = 80

  protocol = "tcp"

  cidr_blocks = ["0.0.0.0/0"]

}
```

---

Iteration 2

```
Port = 8080

Protocol = udp

CIDR = 10.0.0.0/16
```

Creates

```hcl
ingress {

  from_port = 8080

  to_port = 8080

  protocol = "udp"

  cidr_blocks = ["10.0.0.0/16"]

}
```

Terraform continues until every object is converted into an ingress block.

---

# Dynamic Block Flow

```text
Variable (List of Objects)

        │

        ▼

for_each

        │

        ▼

Terraform Loop

        │

        ▼

content{}

        │

        ▼

Ingress Rule 1

Ingress Rule 2

Ingress Rule 3

Ingress Rule 4

        │

        ▼

AWS Security Group Created
```

---

# Dynamic Block vs Static Block

## Static Block

```hcl
ingress {

  from_port = 80

}

ingress {

  from_port = 443

}

ingress {

  from_port = 22

}
```

Advantages

- Easy to read
- Suitable for a few rules

Disadvantages

- Lots of duplicate code
- Difficult to maintain

---

## Dynamic Block

```hcl
dynamic "ingress" {

  for_each = var.sg_ports

  content {

    from_port = ingress.value

  }

}
```

Advantages

- Less code
- Reusable
- Easy maintenance
- Scales well

Disadvantages

- Slightly harder to understand for beginners
- Complex logic can reduce readability

---

# Best Practices

## 1. Use Dynamic Blocks Only When Needed

Good Example

Many ingress rules

Many egress rules

IAM policy statements

Bad Example

Only one ingress block

Dynamic blocks add unnecessary complexity.

---

## 2. Use Structured Variables

Instead of

```text
80

443

22
```

Prefer

```text
Port

Protocol

CIDR
```

This makes configurations more flexible.

---

## 3. Always Use `.value`

Inside the `content` block, access the current loop item using `.value`.

Example:

```hcl
from_port = ingress.value.port
```

---

## 4. Keep Code Readable

Add comments explaining why a dynamic block is used.

Future maintainers will understand the logic more easily.

---

## 5. Test Using terraform plan

Always run:

```bash
terraform plan
```

Verify that Terraform generates the expected nested blocks before applying changes.

---

## 6. Use Modules for Complex Logic

If your dynamic block becomes too complex, consider moving the logic into a reusable Terraform module.

---

# Interview Questions

## What is a Dynamic Block?

A Dynamic Block is used to generate repeated nested blocks automatically using loops.

---

## Why use Dynamic Blocks?

- Reduce duplicate code
- Handle variable-length configurations
- Improve reusability
- Simplify maintenance

---

## What does `for_each` do in a Dynamic Block?

It iterates over a collection (list, map, or set) and creates one nested block for each item.

---

## What is `.value`?

`.value` represents the current item being processed during each iteration of the loop.

---

## When should Dynamic Blocks be used?

- Multiple ingress or egress rules
- IAM policy statements
- Security group rules
- Optional nested blocks
- Repeated nested configurations

---

# Summary

- Dynamic Blocks generate nested blocks automatically using loops.
- They are useful for creating repeated configurations such as security group ingress and egress rules.
- `for_each` iterates over a collection, and `.value` provides access to the current item.
- Use Dynamic Blocks to reduce code duplication, but avoid overusing them for simple configurations.
- Always verify generated blocks with `terraform plan` before applying changes.