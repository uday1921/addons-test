

locals {
  value_file = "${path.root}/Argocd-Apps/values-${var.environment}.yaml"
  target_revision = {
    "dev" : "develop"
    "uat" : "uat"
    "prod" : "master"
  }
  cluster_name       = var.cluster_type == "hub" ? var.hub_cluster_name : var.spoke_cluster_name
  loadbalancername   = lower(replace(local.cluster_name, "[^a-z0-9\\-]", "-"))
  istio_gateway_tags = "Environment=${var.environment},Cluster=${local.cluster_name}"
  argocd_url         = "argocd-${lower(replace(local.cluster_name, "[^a-z0-9\\-]", "-"))}.aws.mot-solutions.com"
  defualt_server     = "https://kubernetes.default.svc"
  endpoint           = var.cluster_type == "hub" ? "https://kubernetes.default.svc" : var.argocd_spoke_endpoint
  argocd_spoke_role  = "arn:aws:iam::${var.account_number}:role/Argocd-spoke-role"
}
resource "helm_release" "argocd" {
  count            = var.cluster_type == "hub" ? 1 : 0
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    file("${path.root}/Addons/argocd-app/values.yaml"),
    yamlencode({
      dummy : uuid()
    })
  ]
}

resource "helm_release" "argocd-project-repo" {
  count     = var.cluster_type == "hub" ? 1 : 0
  chart     = "${path.root}/Addons/argocd-app-repo-crds"
  name      = "argocd-project-repo"
  namespace = "argocd"
  values = [
    file("${path.root}/Addons/argocd-app-repo-crds/values.yaml"),
    yamlencode({
      dummy : uuid()
    })
  ]
  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd_cluster_secret" {
  count     = var.cluster_type == "spoke" ? 1 : 0
  name = "${local.loadbalancername}-cluster-secret"
  chart = "${path.root}/Addons/cluster_secret"
  namespace = "argocd"
  values = [
    templatefile("${path.root}/Addons/cluster_secret/values.yaml",
      { 
        role = local.argocd_spoke_role,
        server = local.endpoint,
        caData = var.argocd_spoke_cadata,
        environment = var.environment,
        cluster_name = local.cluster_name
      }
    ),
    yamlencode({
      dummy : uuid()
    })
  ]
}

# resource "helm_release" "Argocd-parent-app" {
#   chart = "${path.root}/Argocd-Parent-app"
#   # name      = "lower(${var.cluster_name})-addons"
#   name             = lower("${local.cluster_name}-addons")
#   create_namespace = true
#   namespace        = "argocd"
#   values = [
#     templatefile("${path.root}/Argocd-Parent-app/values.yaml",
#       { targetRevision             = local.target_revision[var.environment],
#         environment                = var.environment,
#         loadbalancername           = local.loadbalancername
#         loadbalanceradditionaltags = local.istio_gateway_tags
#         argocd_url                 = local.argocd_url
#         server                     = local.endpoint
#         cluster_type               = var.cluster_type
#         clusterName                = local.cluster_name
#       }
#     ),
#     yamlencode({
#       dummy : uuid()
#     })
#   ]
#   depends_on = [helm_release.argocd, helm_release.argocd-project-repo, helm_release.argocd_cluster_secret]
# }

