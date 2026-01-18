terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "stagging/document-processor/terraform.tfstate"
    region = var.aws_region
  }
}