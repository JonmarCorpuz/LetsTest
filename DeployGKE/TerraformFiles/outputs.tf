# Output the cluster endpoint, useful for configuring kubectl or other integrations.
output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

# Output the cluster's CA certificate in plain text, useful for secure connections.
output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
}