# cGatekeeper

A comprehensive Infrastructure as Code (IaC) security and compliance scanning solution that leverages Cloud Custodian's `c7n-left` module to enforce governance policies on Terraform configurations before deployment.

## What is cGatekeeper?

cGatekeeper is a **GitHub Actions workflow** that serves as an automated security and compliance gatekeeper for your infrastructure code. As a GitHub workflow, it integrates seamlessly into your development process, running automatically on pull requests to scan Terraform configurations against predefined policies before code can be merged.

## How It Works

### Architecture Overview

```
Pull Request → GitHub Actions → c7n-left Scanner → Policy Evaluation → Results
```

### GitHub Workflow Behavior

As a GitHub Actions workflow, cGatekeeper operates with the following characteristics:

- **Event-Driven**: Triggered automatically on pull request events to the `main` branch
- **Ephemeral Execution**: Runs in isolated, disposable Ubuntu containers
- **Branch Protection**: Can be configured as a required status check to prevent merging
- **Parallel Execution**: Runs alongside other CI/CD workflows without interference
- **Zero Infrastructure**: No additional servers or infrastructure required

### Process Flow

1. **Trigger**: Pull request opened/updated against `main` branch
2. **Runner Provisioning**: GitHub provisions fresh Ubuntu 20.04 runner
3. **Environment Setup**: Installs Python 3.11 and Cloud Custodian (`c7n-left`)
4. **Code Checkout**: Downloads the PR branch code to the runner
5. **Policy Scan**: Executes `c7n-left` against Terraform files using defined policies
6. **Results Output**: Displays findings in the GitHub Actions console
7. **Status Report**: Sets workflow status (success/failure) for branch protection

### Policy Engine

The system uses Cloud Custodian policies defined in `.github/policies/cc-checks.yaml` that evaluate:
- **Resource Configuration**: Checks Terraform resource definitions
- **Security Posture**: Validates encryption, access controls, and network security
- **Compliance Standards**: Ensures adherence to organizational governance rules
- **Best Practices**: Enforces cloud architecture recommendations

## Use Cases

### 1. Security Enforcement
- **Encryption at Rest**: Ensures EFS, S3, and SQS resources have proper encryption
- **Network Security**: Prevents public access to RDS instances and EC2 instances
- **Secrets Management**: Detects hardcoded secrets in Lambda environment variables

### 2. Governance & Compliance
- **Resource Tagging**: Enforces mandatory tags (BUID, Label, Owner) for cost allocation and ownership
- **Data Protection**: Requires S3 versioning for data resilience
- **Access Control**: Validates proper IAM configurations and resource permissions

### 3. Cost Management
- **Resource Optimization**: Identifies over-provisioned or unnecessary resources
- **Tagging Compliance**: Ensures proper cost center attribution through mandatory tags

### 4. Risk Mitigation
- **Pre-deployment Validation**: Catches security issues before infrastructure is provisioned
- **Automated Compliance**: Reduces manual review overhead and human error
- **Audit Trail**: Provides documented evidence of security checks for compliance reporting

## Current Policy Coverage

| Policy | Resource Type | Severity | Category |
|--------|---------------|----------|----------|
| Tag Policy Enforcement | All AWS Resources | High | Governance |
| EFS Encryption | `aws_efs` | High | Security/Encryption |
| S3 Server-Side Encryption | `aws_s3_bucket` | High | Encryption |
| S3 Versioning | `aws_s3_bucket` | Medium | Resilience |
| RDS Public Access | `aws_db_instance` | High | Network Security |
| EC2 Public IP | `aws_instance` | Medium | Network Security |
| SQS KMS Encryption | `aws_sqs_queue` | Medium | Encryption |
| Lambda Secrets Detection | `aws_lambda_function` | High | Secrets Management |

## Benefits

### As a GitHub Workflow
- **Native Integration**: Works seamlessly with GitHub's pull request workflow
- **No Additional Infrastructure**: Leverages GitHub's hosted runners
- **Branch Protection**: Integrates with GitHub's branch protection rules
- **Visibility**: Results visible directly in pull request status checks
- **Team Collaboration**: Findings are accessible to all team members in the PR

### Security & Compliance
- **Shift-Left Security**: Identifies issues early in the development lifecycle
- **Automated Compliance**: Reduces manual security reviews and ensures consistent policy enforcement
- **Cost Efficiency**: Prevents deployment of non-compliant resources that might incur additional costs
- **Audit Readiness**: Maintains compliance documentation for regulatory requirements

## Getting Started

1. **Repository Setup**: Copy the `.github/` directory structure to your Terraform repository
2. **Policy Customization**: Modify `.github/policies/cc-checks.yaml` to match your organization's requirements
3. **Workflow Integration**: The GitHub Actions workflow will automatically run on pull requests
4. **Team Training**: Educate developers on policy requirements and remediation steps

## Extending cGatekeeper

- **Custom Policies**: Add new policies to `cc-checks.yaml` for additional compliance requirements
- **Multiple Environments**: Create environment-specific policy files for different deployment stages
- **Integration**: Connect with other security tools like SAST scanners or vulnerability assessments
- **Reporting**: Enhance output formatting or integrate with external compliance dashboards

---

*cGatekeeper helps organizations maintain secure, compliant, and well-governed cloud infrastructure through automated policy enforcement at the code level.*
