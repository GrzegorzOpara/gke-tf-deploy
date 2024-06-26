# gke cluster
data "google_container_engine_versions" "gke_version" {
  location = var.region
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  deletion_protection       = false
  remove_default_node_pool  = true
  initial_node_count        = 1

  network    = var.network_id
  subnetwork = var.subnet_id

  cluster_autoscaling {
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "app-node-pool" {
  name       = "app-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.node_pool_size

  autoscaling {
    min_node_count = 1
    max_node_count = 2
    
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = false
    machine_type = var.node_size
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }    
    labels = {
      app = "flask"
    }
  }
}

resource "google_container_node_pool" "db-node-pool" {
  name       = "db-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]

  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = false
    machine_type = var.node_size
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }    
    labels = {
      app = "db"
    }
  }
}