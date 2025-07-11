## Lesson 5: Terraform AWS Infrastructure

# Project Structure
```
lesson-5/
├── main.tf              # Main configuration file that connects modules
├── backend.tf           # Terraform backend configuration (S3 + DynamoDB)
├── outputs.tf           # Outputs from all modules
├── modules/             # Directory containing Terraform modules
│   ├── s3-backend/      # Module for S3 bucket and DynamoDB for state management
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/             # Module for VPC, subnets, gateways, and routing
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ecr/             # Module for Elastic Container Registry
│       ├── ecr.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md            # Project documentation
```


## AWS CLI Configuration

Before using Terraform, configure your AWS CLI with the appropriate credentials and region:
```
aws configure
```
You will be prompted to enter:

AWS Access Key ID

AWS Secret Access Key

Default region name (e.g., us-west-2)

Default output format (e.g., json)


Terraform Commands
Use the following commands in the root directory (lesson-5) to manage your infrastructure:

Initialize Terraform and download providers:
```
terraform init
```
Preview the changes Terraform will apply:
```
terraform plan
```
Apply the planned changes and provision resources:
```
terraform apply
```
Destroy all provisioned infrastructure:
```
terraform destroy
```
## Modules Explanation

# s3-backend
This module creates the AWS resources necessary to store Terraform state files remotely and enable state locking:

S3 bucket for storing Terraform state files with versioning enabled to keep history.

DynamoDB table for state locking to prevent concurrent Terraform runs and state corruption.

# vpc
This module sets up the network infrastructure in AWS:

Creates a VPC with a specified CIDR block.

Creates three public and three private subnets distributed across availability zones.

Creates an Internet Gateway for public subnet internet access.

Creates NAT Gateways to allow outbound internet access from private subnets.

Configures route tables for public and private subnets.

# ecr
This module provisions an Elastic Container Registry:

Creates an ECR repository to store Docker images.

Enables automatic image scanning on push for security.

Configures access policies for the repository.

