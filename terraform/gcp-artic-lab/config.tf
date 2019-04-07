# Store state in a Cloud Storage bucket
terraform {
  backend "gcs" {
    bucket  = "artic-lab-storage"
    prefix  = "terraform/state"
    project = "artic-lab"
  }
}

# Initialize the Google and Google Beta providers
provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
  zone    = "${var.region}-${var.zone}"
}

provider "google-beta" {
  project = "${var.project_id}"
  region  = "${var.region}"
  zone    = "${var.region}-${var.zone}"
}

# Get client config for authenticating with Kubernetes
data "google_client_config" "default" {
  provider = "google"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
}