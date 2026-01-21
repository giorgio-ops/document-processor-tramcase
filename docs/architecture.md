# Architecture Decistion Records

Here you can find some iof the architectural decutions

- We start from the assumption that there is an existing Kubernetes cluster already running and configured with the appropriate namespace.

- We assume the existence of an AWS account with ID 123456789.

- We also assume that a Terraform state bucket exists, as defined in the backend.tf file.

- Terraform tags have been defined with the minimum required set to identify resources. With more time, a more comprehensive tagging policy could be implemented.

- Regarding the microservice, we assume it is intended for internal use only, as no service.yaml has been defined.

- The _helpers file has been retained to leverage predefined template functions within the manifests. This file provides shared naming conventions and common labels.

- With respect to Argo CD, we assume that an application is already configured.

- A trunk-based branching strategy has been defined and adopted.