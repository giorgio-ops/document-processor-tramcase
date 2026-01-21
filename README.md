# document-processor-tramcase
This repository will be used to store the IaC for a Documment Processor service

# Overview

In this repo we have built the IaC for a microsservice called document processor that will: 
hat will:

- Process legal documents uploaded by tenants
- It will run in Kubernetes with autoscalling
- All the infra is provided via IaC with Terraform
- The Kubernetes application has been configured with Helm to support multienvironment
- ArgosCD has been configured to support the GitOps process
- The service has Prometheus rules to monitor properly the Kubernetes application. 

# Prerrequisites:

This project requires the following tools installed:

|Tool | Version |
|-------- | -------- |
| Terraform  | v1.14.3 |
| Helm | v4.0.5 |
| kubectl | v1.22.5 |

In addition, it requires the following services configured:
 - A running kubernetes cluster with the namespace called document-processor
 - An AWS account ID

 # Setup Instructions

 The deployment of this solution hast to be done in three steps:

## A. Configure the AWS Infrastructure with Terraform

1. Go to the service base folder
```bash
$ cd terraform/emvironments/staging/document-processor
```
2. Configure the AWS credentials. It can be done via aws sso login or direcrtly exporting in the console.

3. Configure the backed.tf with the adecuate name of your terraform state s3 bucket

4. Run terraform init to initialize terraform for this project
```bash
$ terraform init
```
5. You can run terraform validate to check that the file is well structured
```bash
$ terraform validate
```
6. Run terraform plan in order to validate the resources that are going to be created
```bash
$ terraform plan
```
7. If the plan looks good, proceed to apply the infra 
```bash
$ terraform apply
```
Wait some minutes and the infra would be applied with all the required resources. 

## B. Validate the manifests, template the application with Helm and deploy to Kubernetes
1. Execute a lint to validate the manifests
```bash
$ helm lint charts/document-processor
```
2. Template the application to validate what is Kubernetes going to receive
```bash
$ helm template document-processor charts/document-processor -f charts/document-processor/values-staging.yaml
```

3. If everything looks good, deploy the application to Kubernetes:
```bash
$ hhelm install document-processor ./charts/document-processor \
  -n document-processor \
  -f values.yaml \
  -f values-staging.yaml

```

4. Finally you can check if the application is deployed in your cluster running the this commnad
```bash
$ kubectl get pods -n document-processor
```


## C. Promotion process with ArgoCD

ArgoCD helps on the GitOps process to maintain a good management of environemnts while it guarantees the idempotency of what is depoyed on the enviroments. 

For this excersise, we are asuming that we use a trunk based branching strategy which consist on direct commits for maain and the deployment of them to the corresponding environments. 

So, for that the flow is the following:

- Every merge to main deploys to staging
- When validated, you tag that exact commit
- Production tracks the tag

In practical terms, it means that:

1. Every time that I merge to main, it will deploy what is in the document-processort.yaml
2. Once I have done the multiple tests and I am ready to deploy to prod, I need to update my document-processor-production.yaml file with a tag or version.
```bash
spec:
  source:
    targetRevision: release-1.4.0
    helm:
      valueFiles:
        - values.yaml
        - values-production.yaml

```
3. Push to main
4. Create a tag with the same version added in the prod yaml file
```bash
git tag release-1.4.0
```
5. Push taht tag to Git
```bash
git push origin release-1.4.0
```
6. Argo will see the tag and it will deploy to prod. 

## D. Rollback 

Following the same aproach and taking in account that we are following trunk based strategy, the rollback is really easy.

We just need to follow the next steps:

1. Review what was the previous tag released. 
2. Create a revert branch or a new one
3. Update the prod yaml file to use the previous release. Example 
```bash
spec:
  source:
    targetRevision: release-1.3.9
    helm:
      valueFiles:
        - values.yaml
        - values-production.yaml
```
4. Commit and push.

Internally, ArgoCD detects the change, re-renders Helm and reconciles cluster to the old state

# Architecture Decisions:
Can be found in the architecture.md file

# What You’d Improve:
- Starting by Terraform, I would creates modules for every single AWS service separated in different repositories. This is a good practice because it helps to encapsulate one single type of resources, making them more maintainable and reusable with multiple projects. Currently setup is not reusable
- Implementation of Checov to scan infrastructure and find misconfigurations before creating them
- Implement Terragunt for the Terraform management such as environment, states, etc
- Implement unitary tests with Terratest.
- Configure a proper dev - stg - prod chart with Helm
- Define the manifests for dev - stg - prod for ArgoCD
- Implement GitHub Actions to decorarate the PR with check such as: Terraform Linters, Helm Linters, security checks, etc,

# Time Spent

- Terrafornm: 1.5 H
- Helm: 2.5 H
- ArgoCD: 1 H
- Documentation: 1 H
