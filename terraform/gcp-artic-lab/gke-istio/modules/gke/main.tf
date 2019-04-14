locals {
  network_project_id          = "${var.network_project_id != "" ? var.network_project_id : var.project_id}"

  cluster_name                = "${google_container_cluster.primary.0.name}"
  cluster_location            = "${var.zones[0]}"
  cluster_region              = "${var.region}"
  cluster_zone                = "${var.zones[0]}"
  cluster_endpoint            = "${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate      = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
