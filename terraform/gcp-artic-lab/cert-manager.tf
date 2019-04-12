resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"

    labels = {
      app = "cert-manager"
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
  depends_on = ["module.gke"]
}

resource "null_resource" "kube-creds" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${module.gke.name}"
  }
}

resource "null_resource" "cert-manager-prereqs" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml"
  }
  depends_on = ["null_resource.kube-creds"]
}

resource "helm_release" "cert-manager" {
  name = "cert-manager"
  chart = "stable/cert-manager"
  version = "0.6.6"
  namespace = "${kubernetes_namespace.cert-manager.metadata.0.name}"
  set {
    name = "ingressShim.defaultIssuerName"
    value = "letsencrypt-staging"
  }
  set {
    name = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
  set {
    name = "ingressShim.defaultACMEChallengeType"
    value = "http01"
  }
  depends_on = ["null_resource.cert-manager-prereqs"]
}

resource "null_resource" "create-issuers" {
  provisioner "local-exec" {
    command = "kubectl apply -f files/issuers.yaml"
  }
  depends_on = ["helm_release.cert-manager"]
}