terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
  }
}

# Provider configuration for the hub cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_hub.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_hub.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_hub.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_hub.name]
    command     = "aws"
  }
}

# Conditional provider configuration for the spoke cluster

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_hub.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_hub.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_hub.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_hub.name]
    }
  }
}

provider "aws" {
  region = "us-east-1"
}