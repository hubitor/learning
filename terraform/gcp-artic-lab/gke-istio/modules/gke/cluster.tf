resource "google_container_cluster" "primary" {
  provider    = "google-beta"
  name        = "${var.name}"
  description = "${var.description}"
  project     = "${var.project_id}"

  location         = "${var.zones[0]}"

  network            = "${replace(data.google_compute_network.gke_network.self_link, "https://www.googleapis.com/compute/v1/", "")}"
  subnetwork         = "${replace(data.google_compute_subnetwork.gke_subnetwork.self_link, "https://www.googleapis.com/compute/v1/", "")}"

  logging_service    = "${var.logging_service}"
  monitoring_service = "${var.monitoring_service}"

  master_authorized_networks_config = ["${var.master_authorized_networks_config}"]

  addons_config {
    http_load_balancing {
      disabled = "${var.http_load_balancing ? 0 : 1}"
    }

    horizontal_pod_autoscaling {
      disabled = "${var.horizontal_pod_autoscaling ? 0 : 1}"
    }

    kubernetes_dashboard {
      disabled = "${var.kubernetes_dashboard ? 0 : 1}"
    }

    network_policy_config {
      disabled = "${var.network_policy ? 0 : 1}"
    }

    istio_config {
      disabled = "${var.istio ? 0 : 1}"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.ip_range_pods}"
    services_secondary_range_name = "${var.ip_range_services}"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.maintenance_start_time}"
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  node_pool {
    name = "${lookup(var.node_pools[0], "name", "default-pool")}"
    initial_node_count = "${lookup(var.node_pools[0], "initial_node_count", lookup(var.node_pools[0], "min_count", 1))}"
    autoscaling {
      min_node_count = "${lookup(var.node_pools[0], "min_count", 1)}"
      max_node_count = "${lookup(var.node_pools[0], "max_count", 6)}"
    }
    management {
      auto_repair  = "${lookup(var.node_pools[0], "auto_repair", true)}"
      auto_upgrade = "${lookup(var.node_pools[0], "auto_upgrade", false)}"
    }
    node_config {
      image_type   = "${lookup(var.node_pools[0], "image_type", "COS")}"
      machine_type = "${lookup(var.node_pools[0], "machine_type", "n1-standard-2")}"
      labels       = "${merge(map("cluster_name", var.name), map("node_pool", lookup(var.node_pools[0], "name")), var.node_pools_labels["all"], var.node_pools_labels[lookup(var.node_pools[0], "name")])}"
      metadata     = "${merge(map("cluster_name", var.name), map("node_pool", lookup(var.node_pools[0], "name")), var.node_pools_metadata["all"], var.node_pools_metadata[lookup(var.node_pools[0], "name")], map("disable-legacy-endpoints", var.disable_legacy_metadata_endpoints))}"
      taint        = "${concat(var.node_pools_taints["all"], var.node_pools_taints[lookup(var.node_pools[0], "name")])}"
      tags         = ["${concat(list("gke-${var.name}"), list("gke-${var.name}-${lookup(var.node_pools[0], "name")}"), var.node_pools_tags["all"], var.node_pools_tags[lookup(var.node_pools[0], "name")])}"]

      disk_size_gb    = "${lookup(var.node_pools[0], "disk_size_gb", 100)}"
      disk_type       = "${lookup(var.node_pools[0], "disk_type", "pd-standard")}"
      preemptible     = "${lookup(var.node_pools[0], "preemptible", false)}"

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    }
  }
}