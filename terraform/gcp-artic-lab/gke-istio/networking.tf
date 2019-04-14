# Create new VPC
resource "google_compute_network" "vpc" {
  name = "${var.project_name}"
  auto_create_subnetworks = false
}

# Create VPC subnetwork for target region
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "${var.project_name}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc.self_link}"
  secondary_ip_range {
    range_name    = "${var.project_name}-pod-secondary-range"
    ip_cidr_range = "10.96.0.0/11"
  }
  secondary_ip_range {
    range_name    = "${var.project_name}-service-secondary-range"
    ip_cidr_range = "10.94.0.0/18"
  }
}

# Apply default firewall rules to VPC
resource "google_compute_firewall" "allow-icmp" {
  name = "${var.project_name}-allow-icmp"
  network = "${google_compute_network.vpc.self_link}"
  description = "Allow ICMP from anywhere"
  allow {
    protocol = "icmp"
  }
  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-internal" {
  name = "${var.project_name}-allow-internal"
  network = "${google_compute_network.vpc.self_link}"
  description = "Allow internal traffic"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports = ["0-65535"]
  }
  priority = "65534"
  source_ranges = ["10.2.0.0/16"]
}

resource "google_compute_firewall" "allow-ssh" {
  name = "${var.project_name}-allow-ssh"
  network = "${google_compute_network.vpc.self_link}"
  description = "Allow SSH from anywhere"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
}