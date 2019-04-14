resource "google_service_account" "dns-sa" {
  account_id   = "external-dns-${var.project_name}"
  display_name = "A service account for managing Cloud DNS entries via the external-dns app."
}

resource "google_project_iam_member" "dns-sa-dns-admin" {
  project = "${google_service_account.dns-sa.project}"
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.dns-sa.email}"
}

resource "google_service_account_key" "external-dns_sa_key" {
  service_account_id = "${google_service_account.dns-sa.name}"
}

resource "kubernetes_namespace" "external-dns" {
  metadata {
    name = "external-dns"

    labels = {
      app = "external-dns"
    }
  }
  depends_on = ["module.gke"]
}

resource "kubernetes_secret" "external-dns-credentials" {
  metadata {
    name      = "external-dns-credentials"
    namespace = "${kubernetes_namespace.external-dns.metadata.0.name}"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.external-dns_sa_key.private_key)}"
  }
}

resource "helm_release" "external-dns" {
  name = "external-dns"
  chart = "stable/external-dns"
  version = "1.7.3"
  namespace = "${kubernetes_namespace.external-dns.metadata.0.name}"
  set {
    name = "provider"
    value = "google"
  }
  set {
    name = "google.serviceAccountSecret"
    value = "${kubernetes_secret.external-dns-credentials.metadata.0.name}"
  }
  set {
    name = "policy"
    value = "sync"
  }
  set {
    name = "txtOwnerId"
    value = "external-dns-istio"
  }
  set {
    name = "rbac.create"
    value = true
  }
  values = [<<EOF
sources:
  - service
  - ingress
  - istio-gateway
EOF
  ]
}