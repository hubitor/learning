resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
  automount_service_account_token = true
  depends_on = ["module.gke"]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "${kubernetes_service_account.tiller.metadata.0.name}"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  }
}

provider "helm" {
  tiller_image    = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  install_tiller  = true
  service_account = "${kubernetes_cluster_role_binding.tiller.subject.0.name}"
  namespace       = "${kubernetes_cluster_role_binding.tiller.subject.0.namespace}"

  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = "${data.google_client_config.default.access_token}"
    cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
  }
}