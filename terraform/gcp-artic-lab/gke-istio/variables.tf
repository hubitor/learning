variable "project_id" {
  default = "arctic-lab"
}

variable "project_name" {
  default = "gke-istio"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "b"
}

variable "dns_zone" {
  default = "arctic-lab.mattandes.com."
}

variable "helm_version" {
  default = "v2.13.1"
}