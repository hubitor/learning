module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "${var.project_id}"
  name                       = "${var.project_name}"
  region                     = "${var.region}"
  zones                      = ["${var.region}-${var.zone}"]
  regional                   = false
  network                    = "${google_compute_network.vpc.name}"
  subnetwork                 = "${google_compute_subnetwork.vpc_subnetwork.name}"
  ip_range_pods              = "${google_compute_subnetwork.vpc_subnetwork.secondary_ip_range.0.range_name}"
  ip_range_services          = "${google_compute_subnetwork.vpc_subnetwork.secondary_ip_range.1.range_name}"
  service_account            = "create"
  remove_default_node_pool   = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 3
      max_count          = 3
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 3
    },
  ]

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = "true"
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}