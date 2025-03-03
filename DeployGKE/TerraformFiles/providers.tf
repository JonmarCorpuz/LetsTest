terraform {
    required_version = ">= 1.0.0"

    required_providers {
        google = {
          source  = "hashicorp/google"
        }
    
        google-beta = {
          source  = "hashicorp/google-beta"
        }
    }
}

provider "google" {
    credentials = "keys.json"
    project = PROJECT_ID
    region = PROJECT_REGION
}

provider "kubernetes" {
  load_config_file       = false
  host                   = google_container_cluster.gke_cluster.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
}

data "google_client_config" "default" {}
