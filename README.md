# document-processor-tramcase

This repository contains the Infrastructure as Code (IaC) for the **Document Processor** service.

---

## Overview

This repository contains the IaC for a microservice called **Document Processor**, which:

- Processes legal documents uploaded by tenants
- Runs on Kubernetes with autoscaling enabled
- Is fully provisioned using Terraform
- Uses Helm to support multi-environment deployments
- Uses Argo CD to enable a GitOps-based deployment process
- Includes Prometheus rules to properly monitor the Kubernetes application

---

## Prerequisites

This project requires the following tools to be installed:

| Tool      | Version |
|-----------|---------|
| Terraform | v1.14.3 |
| Helm      | v4.0.5  |
| kubectl  | v1.22.5 |

Additionally, the following prerequisites must be in place:

- A running Kubernetes cluster with a namespace named `document-processor`
- An AWS account ID

---

## Setup Instructions

The deployment of this solution must be completed in three steps.

---

## A. Configure the AWS Infrastructure with Terraform

1. Navigate to the service environment folder:
```bash
cd terraform/environments/staging/document-processor
```

2. Configure AWS credentials. This can be done using `aws sso login` or by exporting credentials directly in the shell.

3. Configure the `backend.tf` file with the correct name of your Terraform state S3 bucket.

4. Initialize Terraform:
```bash
terraform init
```

5. Validate the Terraform configuration:
```bash
terraform validate
```

6. Review the execution plan:
```bash
terraform plan
```

7. If everything looks correct, apply the infrastructure:
```bash
terraform apply
```

After a few minutes, the infrastructure will be provisioned with all required resources.

---

## B. Validate Manifests, Template the Application with Helm, and Deploy to Kubernetes

1. Run a Helm lint to validate the chart:
```bash
helm lint charts/document-processor
```

2. Render the Helm templates to inspect what Kubernetes will receive:
```bash
helm template document-processor charts/document-processor \
  -f charts/document-processor/values-staging.yaml
```

3. If everything looks good, deploy the application:
```bash
helm install document-processor ./charts/document-processor \
  -n document-processor \
  -f values.yaml \
  -f values-staging.yaml
```

4. Verify that the application is running:
```bash
kubectl get pods -n document-processor
```

---

## C. Promotion Process with Argo CD

Argo CD enables a GitOps workflow to manage environments while guaranteeing idempotent deployments.

For this project, we assume a **trunk-based development strategy**, where changes are committed directly to `main` and promoted through environments.

### Promotion Flow

- Every merge to `main` deploys to **staging**
- Once validated, the commit is tagged
- **Production** tracks the tag

### Practical Steps

1. Every merge to `main` deploys the configuration defined in `document-processor.yaml`.

2. Once validation is complete and the service is ready for production, update `document-processor-production.yaml` with a release tag:
```yaml
spec:
  source:
    targetRevision: release-1.4.0
    helm:
      valueFiles:
        - values.yaml
        - values-production.yaml
```

3. Push the changes to `main`.

4. Create a Git tag matching the production version:
```bash
git tag release-1.4.0
```

5. Push the tag:
```bash
git push origin release-1.4.0
```

6. Argo CD detects the new tag and deploys it to production.

---

## D. Rollback

Using the same trunk-based approach, rolling back is straightforward.

### Rollback Steps

1. Identify the previously deployed release tag.
2. Create a revert or fix branch.
3. Update the production manifest to point to the previous release:
```yaml
spec:
  source:
    targetRevision: release-1.3.9
    helm:
      valueFiles:
        - values.yaml
        - values-production.yaml
```
4. Commit and push the change.

Argo CD will detect the update, re-render the Helm chart, and reconcile the cluster to the previous state.

---

## Architecture Decisions

Architecture decisions are documented in the [architecture](docs/architecture.md) file.

---

## What I’d Improve

- Refactor Terraform code into reusable modules, one per AWS service, ideally stored in separate repositories
- Add **Checkov** to scan infrastructure for security and configuration issues
- Introduce **Terragrunt** to better manage environments, remote state, and dependencies
- Implement infrastructure unit tests using **Terratest**
- Define separate Helm values for `dev`, `stg`, and `prod`
- Create dedicated Argo CD manifests per environment

---

## Time Spent

- Terraform: 1.5 h  
- Helm: 2.5 h  
- Argo CD: 1 h  
- Documentation: 1 h  
