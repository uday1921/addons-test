module "k8s-addons" {
  source                = "./Addons-terraform-module"
  environment           = var.environment
  spoke_cluster_name    = var.spoke_cluster_name
  hub_cluster_name      = var.hub_cluster_name
  cluster_type          = var.cluster_type
  argocd_version        = var.argocd_version
  account_number        = var.account_number
  argocd_spoke_endpoint = var.cluster_type == "spoke" ? data.aws_eks_cluster.eks_spoke[0].endpoint : ""
  argocd_spoke_cadata   = var.cluster_type == "spoke" ? data.aws_eks_cluster.eks_spoke[0].certificate_authority[0].data : ""
}
