# Obelion Cloud Automation Assessment

This repository contains the assessment tasks for the Obelion Cloud Automation role.

## TaskGroup A

The infrastructure code and documentation for TaskGroup A can be found in the [TaskGroupA](./TaskGroupA) directory.
.
├── environments/       # Environment-specific configurations (dev)
│   └── dev/            # Development environment
│       ├── main.tf     # Main configuration entry point
│       ├── variables.tf# Variable definitions
│       ├── outputs.tf  # Output definitions
│       └── backend.tf  # Backend configuration
├── modules/            # Reusable Terraform modules
│   ├── network/        # VPC, Subnets, IGW, Route Tables
│   ├── ec2/            # EC2 Instances, Security Groups
│   ├── rds/            # RDS Database
│   ├── cloudwatch/     # CloudWatch monitoring
│   ├── iam/            # IAM roles and policies
│   └── kms_and_secrets_manager/ # KMS and Secrets Manager
└── README.md           # Project documentation
```

## TaskGroup B

This section details the repositories and screenshots for TaskGroup B.

### TaskGroup B1: Uptime Kuma

*   **Repository:** [https://github.com/Ahmedheggy/uptime-kuma.git](https://github.com/Ahmedheggy/uptime-kuma.git)

#### Screenshots

![TaskGroupB1](./Task-GroupB/Task-GroupB1/TaskGroupB1.png)
![TaskGroupB-1](./Task-GroupB/Task-GroupB1/TaskGroupB-1.png)
![Deployment](./Task-GroupB/Task-GroupB1/Deployment.png)
### TaskGroup B2: Laravel Application

*   **Repository:** [https://github.com/Ahmedheggy/laravel.git](https://github.com/Ahmedheggy/laravel.git)

#### Screenshots

![TaskGroupB2](./Task-GroupB/Task-GroupB2/TaskGroupB2.png)
![Migration Proof](./Task-GroupB/Task-GroupB2/migration-prove.png)
