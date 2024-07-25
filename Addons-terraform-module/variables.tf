variable "argocd_version" {
  type        = string
  default     = ""
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
variable "hub_cluster_name" {
  type        = string
  default     = ""
  description = "Name of the Kubernetes cluster"
}
variable "cluster_type" {
  type        = string
  default     = "hub"
  description = "Type of the cluster hub or spoke"
}
variable "endpoint" {
  type        = string
  default     = ""
  description = "Endpoint of the EKS cluster"
}
variable "account_number" {
  type        = string
  description = "AWS account number"
  default     = ""
}
variable "argocd_spoke_endpoint" {
  type        = string
  description = "ArgoCD endpoint for spoke cluster"
  default     = ""
}
variable "argocd_spoke_cadata" {
  type        = string
  description = "ArgoCD endpoint for spoke cluster"
  default     = ""
}