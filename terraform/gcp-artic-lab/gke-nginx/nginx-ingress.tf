resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"

    labels = {
      app = "nginx-ingress"
    }
  }
  depends_on = ["module.gke"]
}

resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  version = "1.4.0"
  namespace = "${kubernetes_namespace.nginx-ingress.metadata.0.name}"
  set {
    name = "controller.publishService.enabled"
    value = true
  }
  set {
    name = "controller.replicaCount"
    value = 2
  }
  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  set {
    name = "controller.stats.enabled"
    value = true
  }
  set {
    name = "controller.metrics.enabled"
    value = true
  }
  values = [<<EOF
controller:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "10254"
EOF
  ]
}