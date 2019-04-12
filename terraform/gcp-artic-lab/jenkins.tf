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
  set {
    name = "Master.ingress.hostName"
    value = "jenkins.arctic-lab.mattandes.com"
  }
}
