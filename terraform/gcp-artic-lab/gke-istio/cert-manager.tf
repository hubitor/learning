resource "google_service_account" "cm-sa" {
  account_id   = "cert-manager-${var.project_name}"
  display_name = "A service account for managing Cloud DNS entries via the cert-manager app."
}

resource "google_project_iam_member" "cm-dns-admin" {
  project = "${google_service_account.cm-sa.project}"
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.cm-sa.email}"
}

resource "google_service_account_key" "cm_sa_key" {
  service_account_id = "${google_service_account.cm-sa.name}"
}

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

resource "kubernetes_secret" "cm-dns-credentials" {
  metadata {
    name      = "cm-dns-credentials"
    namespace = "${kubernetes_namespace.cert-manager.metadata.0.name}"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.cm_sa_key.private_key)}"
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
    value = "dns01"
  }
  depends_on = ["null_resource.cert-manager-prereqs"]
}

resource "null_resource" "create-issuers" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/cluster-issuers.yaml"
  }
  depends_on = ["helm_release.cert-manager"]
}

resource "null_resource" "istio-wildcard" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/istio-wildcard-cert.yaml"
  }
  depends_on = ["null_resource.create-issuers","null_resource.kube-creds"]
}