terraform {
  backend "gcs" {
    bucket = "gke-tf-state-bucket"
  }
}