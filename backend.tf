# Cluster name to be provided as input to the Github workflow
# For example: terraform init -backend-config="key=AWS/EKS/${{github.event.inputs.cluster_name}}/terraform.tfstate"
terraform {
  backend "s3" {
    bucket         = "terraform-s3-state-mcap"
    dynamodb_table = "iac-terraform-state-lock-dynamo-sandbox"
    region         = "us-east-1"
    cluster_name   = var.hub_cluster_name
  }
}