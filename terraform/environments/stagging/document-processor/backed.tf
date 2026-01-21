terraform {
  # Specifies the required Terraform CLI version
  required_version = "1.14.3"
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "stagging/document-processor/terraform.tfstate"
    region = var.aws_region
  }
}