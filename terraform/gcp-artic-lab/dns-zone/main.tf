# Store state in a Cloud Storage bucket
terraform {
  backend "gcs" {
    bucket  = "artic-lab-storage"
    prefix  = "terraform/state/dns"
    project = "artic-lab"
  }
}

# Initialize the Google providers
provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
  zone    = "${var.region}-${var.zone}"
}

# Create DNS zone
resource "google_dns_managed_zone" "external" {
  name = "${var.project_name}"
  dns_name = "${var.dns_zone}"
  description = "External DNS zone"
  provisioner "local-exec" {
    when    = "destroy"
    command = "./clear-dns-zone.ps1 ${var.project_name}"
    interpreter = ["PowerShell", "-Command"]
  }
}
