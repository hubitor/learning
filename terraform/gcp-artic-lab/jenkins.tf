resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"

    labels = {
      app = "jenkins"
    }
  }
  depends_on = ["module.gke"]
}

resource "helm_release" "jenkins" {
  name = "jenkins"
  chart = "stable/jenkins"
  version = "0.37.0"
  namespace = "${kubernetes_namespace.jenkins.metadata.0.name}"
  set {
    name = "Master.ingress.enabled"
    value = true
  }
  set {
    name = "Master.ServiceType"
    value = "NodePort"
  }
  set {
    name = "Master.ServicePort"
    value = "80"
  }
}

/*data "kubernetes_service" "jenkins" {
  metadata {
    name = "${helm_release.jenkins.name}"
    namespace = "${kubernetes_namespace.jenkins.metadata.0.name}"
  }
}

resource "google_dns_record_set" "jenkins" {
  name = "jenkins.${google_dns_managed_zone.external.dns_name}"
  managed_zone = "${google_dns_managed_zone.external.name}"
  type = "A"
  ttl  = 300

  rrdatas = ["${data.kubernetes_service.jenkins.load_balancer_ingress.0.ip}"]
}*/