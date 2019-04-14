variable "project_id" {
  description = "The project ID to host the cluster in (required)"
}

variable "name" {
  description = "The name of the cluster (required)"
}

variable "description" {
  description = "The description of the cluster"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in (required)"
}

variable "zones" {
  type = "list"
  description = "The zones to host the cluster in"
  default     = [""]
}

variable "network" {
  description = "The VPC network to host the cluster in (required)"
}

variable "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in (required)"
}

variable "master_authorized_networks_config" {
  type = "list"

  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)

  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
    }],
  }]

  EOF

  default = []
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing" {
  description = "Enable httpload balancer addon"
  default     = true
}

variable "kubernetes_dashboard" {
  description = "Enable kubernetes dashboard addon"
  default     = false
}

variable "network_policy" {
  description = "Enable network policy addon"
  default     = false
}

variable "istio" {
  description = "Enable Istio addon"
  default     = false
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "ip_range_pods" {
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  description = "The _name_ of the secondary subnet range to use for services"
}


variable "disable_legacy_metadata_endpoints" {
  description = "Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated."
  default     = "true"
}


variable "node_pools" {
  type        = "list"
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "node_pools_labels" {
  type        = "map"
  description = "Map of maps containing node labels by node-pool name"

  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_metadata" {
  type        = "map"
  description = "Map of maps containing node metadata by node-pool name"

  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_taints" {
  type        = "map"
  description = "Map of lists containing node taints by node-pool name"

  default = {
    all               = []
    default-node-pool = []
  }
}

variable "node_pools_tags" {
  type        = "map"
  description = "Map of lists containing node network tags by node-pool name"

  default = {
    all               = []
    default-node-pool = []
  }
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com"
}
