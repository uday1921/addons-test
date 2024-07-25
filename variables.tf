variable "argocd_version" {
  type        = string
  default     = "7.3.4"
  description = "ArgoCD version to be installed on the EKS cluster"
}
variable "environment" {
  type        = string
  default     = "dev"
  description = "Branch to be used for the deployment"
}
variable "spoke_cluster_name" {
  type        = string
  default     = ""
  description = "Name of the Kubernetes cluster"
}
variable "cluster_type" {
  type        = string
  default     = "hub"
  description = "Type of the cluster hub or spoke"
}

variable "account_number" {
  type        = string
  description = "AWS account number"
  default     = "010880705595"
}

variable "hub_cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
  default     = ""

}