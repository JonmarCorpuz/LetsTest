# Create a GKE cluster resource.
resource "google_container_cluster" "gke_cluster" {
  name     = "CLUSTER_NAME"    # Name of the GKE cluster
  location = "CLUSTER_REGION"              # The location for the cluster

  # Do not create a default node pool upon cluster creation. This is useful for custom node pool configurations.
  remove_default_node_pool = true
  initial_node_count       = 1                # Initial number of nodes when not using default node pool

  # Master authentication settings, disable basic authentication and client certificate.
  master_auth {
    username = ""                       # Empty username disables basic authentication
    password = ""                       # Empty password disables basic authentication

    client_certificate_config {
      issue_client_certificate = false  # Disable client certificate issuance
    }
  }
}

# Create a node pool for the GKE cluster defined above.
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "NODE_POOL_NAME"        # Name of the node pool
  location   = "CLUSTER_REGION"              # Location must match the cluster location
  cluster    = google_container_cluster.gke_cluster.name  # Reference to the associated cluster

  node_count = 1                          # Number of nodes in the node pool

  # Configuration for nodes in the node pool.
  node_config {
    preemptible  = true                   # Use preemptible VMs which are cheaper but short-lived
    machine_type = "NODE_MACHINE_TYPE"            # Type of machine to use for nodes
  }
}

resource "kubernetes_manifest" "daemon_sets" {
  manifest = yamldecode(file("${path.module}/daemonSets.yaml"))
}

resource "kubernetes_manifest" "deployments" {
  manifest = yamldecode(file("${path.module}/deployments.yaml"))
}

resource "kubernetes_manifest" "persistent_volume_claims" {
  manifest = yamldecode(file("${path.module}/persistentVolumeClaims.yaml"))
}

resource "kubernetes_manifest" "services" {
  manifest = yamldecode(file("${path.module}/services.yaml"))
}

resource "kubernetes_manifest" "cron_jobs" {
  manifest = yamldecode(file("${path.module}/cronJobs.yaml"))
}

resource "kubernetes_manifest" "config_maps" {
  manifest = yamldecode(file("${path.module}/configMaps.yaml"))
}
