data "aws_eks_cluster" "eks_hub" {
  name = var.hub_cluster_name
}

data "aws_eks_cluster_auth" "eks_hub" {
  name = var.hub_cluster_name
}

data "aws_eks_cluster" "eks_spoke" {
  count = var.cluster_type == "spoke" ? 1 : 0
  name  = var.spoke_cluster_name
}
data "aws_eks_cluster_auth" "eks_spoke" {
  count = var.cluster_type == "spoke" ? 1 : 0
  name  = var.spoke_cluster_name
}
