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


## 1. Configure the ArgoCD