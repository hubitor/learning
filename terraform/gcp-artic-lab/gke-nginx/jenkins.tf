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
    value = "ClusterIP"
  }
  set {
    name = "Master.ServicePort"
    value = "80"
  }
  set {
    name = "Master.ingress.hostName"
    value = "jenkins.${var.project_name}.arctic-lab.mattandes.com"
  }
  set {
    name = "Master.ingress.path"
    value = "/"
  }
  values = [<<EOF
Master:
  ingress:
    annotations:
      kubernetes.io/ingress.class: "nginx"
      kubernetes.io/tls-acme: "true"
    tls:
      - secretName: jenkins-tls-cert
        hosts:
          - jenkins.${var.project_name}.arctic-lab.mattandes.com
EOF
  ]
}
