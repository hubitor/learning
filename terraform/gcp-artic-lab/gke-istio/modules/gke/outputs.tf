output "name" {
  description = "Cluster name"
  value       = "${local.cluster_name}"
}

output "location" {
  description = "Cluster location"
  value       = "${local.cluster_location}"
}

output "region" {
  description = "Cluster region"
  value       = "${local.cluster_region}"
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = "${local.cluster_endpoint}"
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = "${local.cluster_ca_certificate}"
}
